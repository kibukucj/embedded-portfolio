# The Code That Realized The Student Attendance Tracker

<span class="week-tag">Final Week · Documentation</span>

## 1. Introduction

The following in the code compile and uploaded to the ESP32 microcontroller.

## 2. Code

```c
#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <SPI.h>
#include <MFRC522.h>
#include <Preferences.h>

#define STASSID "**"
#define STAPSK "**********"

#define RST_PIN 22  
#define SS_PIN  21  

MFRC522 mfrc522(SS_PIN, RST_PIN);
WebServer server(80);
Preferences preferences;

// Global placeholder to capture a newly tapped card waiting to be onboarded
String lastScannedUnknownUID = ""; 

struct Student {
  String uid;
  String name;
  String idNum;
  String course;
  String status; 
};

// Max limit of slots available in flash partitioning space
const int MAX_STUDENTS = 20; 
Student students[MAX_STUDENTS];
int currentStudentCount = 0;

// --- FRONTEND: Main Attendance Dashboard ---
void handleRoot() {
  String html = "<!DOCTYPE html>\
<html lang='en'>\
<head>\
    <meta charset='UTF-8'>\
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\
    <title>RFID Dashboard</title>\
    <style>\
        :root { --bg-color: #f4f6f9; --card-bg: #ffffff; --text-color: #333333; --present-color: #2ec4b6; --absent-color: #e71d36; --border-color: #e0e0e0; }\
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; padding: 20px; display: flex; justify-content: center; }\
        .container { width: 100%; max-width: 900px; background: var(--card-bg); padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }\
        h1 { text-align: center; color: #2c3e50; }\
        .nav-links { text-align: center; margin-bottom: 20px; }\
        .nav-links a { margin: 0 10px; color: #3498db; text-decoration: none; font-weight: bold; }\
        .stats-container { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 30px; text-align: center; }\
        .stat-card { padding: 15px; border-radius: 8px; color: white; font-weight: bold; }\
        .stat-card.present { background-color: var(--present-color); }\
        .stat-card.absent { background-color: var(--absent-color); }\
        .stat-count { font-size: 1.8rem; display: block; margin-top: 5px; }\
        .attendance-table { width: 100%; border-collapse: collapse; }\
        .attendance-table th, .attendance-table td { padding: 12px; text-align: left; border-bottom: 1px solid var(--border-color); }\
        .attendance-table th { background-color: #f8f9fa; color: #34495e; }\
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; color: white; font-weight: bold; }\
        .badge-Present { background-color: var(--present-color); }\
        .badge-Absent { background-color: var(--absent-color); }\
        .clear-btn { display:block; width:100%; padding:10px; background:#e71d36; color:white; border:none; border-radius:6px; font-weight:bold; cursor:pointer; margin-top:20px; }\
    </style>\
</head>\
<body>\
<div class='container'>\
    <h1>Class Attendance Records</h1>\
    <div class='nav-links'><a href='/'>Dashboard</a> | <a href='/onboard'>Onboard New Student</a></div>\
    <div class='stats-container'>\
        <div class='stat-card present'>Present <span id='pCount'>0</span></div>\
        <div class='stat-card absent'>Absent <span id='aCount'>0</span></div>\
    </div>\
    <table class='attendance-table'>\
        <thead><tr><th>Name</th><th>Student ID</th><th>Course</th><th>Status</th></tr></thead>\
        <tbody id='list'></tbody>\
    </table>\
    <button class='clear-btn' onclick='clearAll()'>Reset Attendance Statuses</button>\
</div>\
<script>\
    async function refresh() {\
        let res = await fetch('/get-attendance');\
        let data = await res.json();\
        let tbody = document.getElementById('list'); tbody.innerHTML = '';\
        let p = 0, a = 0;\
        data.forEach(s => {\
            if(s.status=='Present') p++; else a++;\
            tbody.innerHTML += `<tr><td><strong>${s.name}</strong></td><td>${s.idNum}</td><td>${s.course}</td><td><span class='badge badge-${s.status}'>${s.status}</span></td></tr>`;\
        });\
        document.getElementById('pCount').textContent = p;\
        document.getElementById('aCount').textContent = a;\
    }\
    async function clearAll() { if(confirm('Reset status back to absent?')) { await fetch('/clear', {method:'POST'}); refresh(); } }\
    setInterval(refresh, 1500); refresh();\
</script>\
</body>\
</html>";
  server.send(200, "text/html", html);
}

// --- FRONTEND: Dynamic Onboarding Registration Page ---
void handleOnboardPage() {
  String html = "<!DOCTYPE html>\
<html lang='en'>\
<head>\
    <meta charset='UTF-8'>\
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\
    <title>Onboard Student</title>\
    <style>\
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; padding: 20px; display: flex; justify-content: center; }\
        .container { width: 100%; max-width: 500px; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }\
        h1 { text-align: center; color: #2c3e50; }\
        .nav-links { text-align: center; margin-bottom: 20px; }\
        .nav-links a { margin: 0 10px; color: #3498db; text-decoration: none; font-weight: bold; }\
        .scan-box { background: #e8f4fd; padding: 15px; border-radius: 6px; text-align: center; margin-bottom: 20px; font-weight: bold; color: #2980b9; border: 1px dashed #3498db; }\
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #34495e; }\
        input[type='text'] { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; }\
        button { width: 100%; padding: 12px; background: #2ec4b6; color: white; border: none; border-radius: 6px; font-size: 1rem; font-weight: bold; cursor: pointer; }\
        button:disabled { background: #ccc; cursor: not-allowed; }\
    </style>\
</head>\
<body>\
<div class='container'>\
    <h1>Onboard Student</h1>\
    <div class='nav-links'><a href='/'>Dashboard</a> | <a href='/onboard'>Onboard New Student</a></div>\
    <div id='scanStatus' class='scan-box'>Waiting for Card Scan...</div>\
    <form action='/register' method='POST' id='regForm'>\
        <input type='hidden' name='uid' id='formUid'>\
        <label>Full Name</label><input type='text' name='name' required>\
        <label>Student ID Number</label><input type='text' name='idNum' required>\
        <label>Course Name</label><input type='text' name='course' required>\
        <button type='submit' id='subBtn' disabled>Register Student</button>\
    </form>\
</div>\
<script>\
    async function checkScan() {\
        let res = await fetch('/check-unregistered');\
        let uid = await res.text();\
        if(uid && uid !== '') {\
            document.getElementById('scanStatus').innerHTML = '✅ Card Detected! UID: ' + uid;\
            document.getElementById('scanStatus').style.background = '#e8fdf5';\
            document.getElementById('scanStatus').style.color = '#27ae60';\
            document.getElementById('scanStatus').style.borderColor = '#2ec4b6';\
            document.getElementById('formUid').value = uid;\
            document.getElementById('subBtn').disabled = false;\
        }\
    }\
    setInterval(checkScan, 1000);\
</script>\
</body>\
</html>";
  server.send(200, "text/html", html);
}

// --- DATA ACTION: Handle Form Submission and Write to Flash ---
void handleRegister() {
  if (currentStudentCount >= MAX_STUDENTS) {
    server.send(200, "text/plain", "Error: Database Full!");
    return;
  }
  
  String formUid = server.arg("uid");
  String formName = server.arg("name");
  String formIdNum = server.arg("idNum");
  String formCourse = server.arg("course");

  // Save dynamically into runtime array structures
  students[currentStudentCount] = {formUid, formName, formIdNum, formCourse, "Absent"};
  
  // Save permanently into non-volatile memory namespaces
  preferences.begin("db", false);
  String baseKey = "s" + String(currentStudentCount);
  preferences.putString((baseKey + "uid").c_str(), formUid);
  preferences.putString((baseKey + "name").c_str(), formName);
  preferences.putString((baseKey + "id").c_str(), formIdNum);
  preferences.putString((baseKey + "crs").c_str(), formCourse);
  
  currentStudentCount++;
  preferences.putInt("count", currentStudentCount);
  preferences.end();

  lastScannedUnknownUID = ""; // Wipe temporary placeholder string clean
  
  // Redirect supervisor back to home dashboard automatically
  server.sendHeader("Location", "/", true);
  server.send(303, "text/plain", "Redirecting...");
}

void handleGetAttendance() {
  String json = "[";
  for (int i = 0; i < currentStudentCount; i++) {
    json += "{\"name\":\"" + students[i].name + "\",\"idNum\":\"" + students[i].idNum + "\",\"course\":\"" + students[i].course + "\",\"status\":\"" + students[i].status + "\"}";
    if (i < currentStudentCount - 1) json += ",";
  }
  json += "]";
  server.send(200, "application/json", json);
}

void handleCheckUnregistered() {
  server.send(200, "text/plain", lastScannedUnknownUID);
}

void handleClearAttendance() {
  preferences.begin("status", false);
  for (int i = 0; i < currentStudentCount; i++) {
    students[i].status = "Absent";
    preferences.putString(String(i).c_str(), "Absent");
  }
  preferences.end();
  server.send(200, "text/plain", "Cleared");
}

void setup() {
  Serial.begin(115200);
  SPI.begin();
  mfrc522.PCD_Init();
  delay(4);
  
  // 1. Get the total student headcount from "db" namespace
  preferences.begin("db", true); 
  currentStudentCount = preferences.getInt("count", 0);
  preferences.end(); // Cleanly close it immediately

  // 2. Loop through and pull each student's profile details
  for(int i = 0; i < currentStudentCount; i++) {
    preferences.begin("db", true); // Open "db" partition safely
    String baseKey = "s" + String(i);
    String u = preferences.getString((baseKey + "uid").c_str(), "");
    String n = preferences.getString((baseKey + "name").c_str(), "");
    String id = preferences.getString((baseKey + "id").c_str(), "");
    String c = preferences.getString((baseKey + "crs").c_str(), "");
    preferences.end(); // Cleanly close "db" partition
    
    // 3. Open the "status" partition independently to get their attendance history
    preferences.begin("status", true); 
    String stat = preferences.getString(String(i).c_str(), "Absent");
    preferences.end(); // Cleanly close "status" partition
    
    // Assign data safely to memory layout array row
    students[i] = {u, n, id, c, stat};
  }

  // Network initialization stack
  WiFi.mode(WIFI_STA);
  WiFi.begin(STASSID, STAPSK);
  while (WiFi.status() != WL_CONNECTED) { delay(500); Serial.print("."); }
  Serial.printf("\nConnected. IP: %s\n", WiFi.localIP().toString().c_str());

  MDNS.begin("attendance");

  server.on("/", handleRoot);
  server.on("/onboard", handleOnboardPage);
  server.on("/register", HTTP_POST, handleRegister);
  server.on("/get-attendance", handleGetAttendance);
  server.on("/check-unregistered", handleCheckUnregistered);
  server.on("/clear", HTTP_POST, handleClearAttendance);
  server.begin();
}

void loop() {
  server.handleClient();
  delay(2);

  if (!mfrc522.PICC_IsNewCardPresent() || !mfrc522.PICC_ReadCardSerial()) return;

  String scannedUID = "";
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    scannedUID += String(mfrc522.uid.uidByte[i] < 0x10 ? "0" : "");
    scannedUID += String(mfrc522.uid.uidByte[i], HEX);
    if (i < mfrc522.uid.size - 1) scannedUID += " ";
  }
  scannedUID.toUpperCase();

  bool knownCard = false;
  for (int i = 0; i < currentStudentCount; i++) {
    if (students[i].uid == scannedUID) {
      if(students[i].status != "Present") {
        students[i].status = "Present";
        preferences.begin("status", false);
        preferences.putString(String(i).c_str(), "Present");
        preferences.end();
      }
      knownCard = true;
      break;
    }
  }

  // If card is not found in database, store it in the pending placeholder variable
  if (!knownCard) {
    lastScannedUnknownUID = scannedUID;
    Serial.printf("New Card Detected! Ready for onboarding on web page. UID: %s\n", scannedUID.c_str());
  }

  mfrc522.PICC_HaltA();
}
```


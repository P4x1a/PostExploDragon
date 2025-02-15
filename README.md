# PostExploDragon.ps1

## 📌 Description
**PostExploDragon.ps1** is a PowerShell post-exploitation script that collects detailed system information from a compromised machine and generates a CSV report. The script includes distraction elements to confuse the target, along with visual and sound effects.

---

## ⚙️ Features
✅ Collects operating system, hardware, network, and user information.<br>
✅ Extracts data on processes, services, installed programs, and event logs.<br>
✅ Analyzes firewall rules and scheduled tasks.<br>
✅ Generates a structured CSV report.<br>
✅ Includes visual and sound distractions."<br>

---

## 📂 Script Structure

The script executes the following steps:
1. **Displays fake progress messages** to distract the user.
2. **Asynchronously collects system data.**
3. **Saves the gathered information** into a CSV file.
4. **Triggers visual and sound effects** to enhance dramatization.

---

## 🛠️ Requirements
- Windows PowerShell 5.1 or later.
- Administrative privileges (to access certain information).

---

## 🚀 How to Use

1. **Open PowerShell as Administrator.**
2. **Run the script:**
   ```powershell
   .\PostExploDragon.ps1 -outputFile "C:\Temp\report.csv"
   ```
3. **Wait for the data collection to complete.**
4. **Check the generated report at the specified location.**

---

## 📋 Sample Output

A snippet of the generated CSV file:

```csv
Category, Name, Value
System, Name, DESKTOP-XYZ123
Operating System, Name, Windows 10 Pro
CPU, Name, Intel(R) Core(TM) i7-9700K CPU @ 3.60GHz
Memory, Capacity, 16 GB
Network, Adapter, Ethernet0
Network, IP Address, 192.168.1.100
```

---

## ⚠️ Disclaimer
This script is intended **for educational and internal auditing purposes only**. Unauthorized use may be considered malicious activity.

---

## 📜 License
This project is licensed under the MIT License. See the `LICENSE` file for details.

📌 **Author:** Gian Silva  



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        label {
            margin-top: 10px;
            display: block;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="password"],
        input[type="date"],
        input[type="time"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            resize: none;
        }
        button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #218838;
        }
        .medical-history {
            margin-top: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: #f9f9f9;
        }
        .history-entry {
            border-bottom: 1px solid #ddd;
            padding: 10px 0;
        }
        .history-entry:last-child {
            border-bottom: none;
        }
        .uploaded-file {
            color: green;
        }
        .history-entry p {
            margin: 5px 0;
            color: #333;
        }
        .history-entry strong {
            color: #555;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Patient Login</h1>
        <form id="loginForm">
            <label for="loginPatientID">Patient ID:</label>
            <input type="text" id="loginPatientID" placeholder="Enter your unique patient ID" required>

            <label for="loginPassword">Password:</label>
            <input type="password" id="loginPassword" placeholder="Enter your password" required>

            <button type="submit">Login</button>
        </form>

        <div id="medicalHistoryContainer" style="display: none;">
            <h1>Add Medical History</h1>
            <form id="medicalHistoryForm">
                <label for="patientName">Patient Name:</label>
                <input type="text" id="patientName" placeholder="Enter patient's name" required>

                <label for="doctorName">Doctor's Name:</label>
                <input type="text" id="doctorName" placeholder="Enter doctor's name" required>

                <label for="doctorID">Doctor's ID:</label>
                <input type="text" id="doctorID" placeholder="Enter unique doctor ID" required>

                <label for="date">Date:</label>
                <input type="date" id="date" required>

                <label for="time">Time:</label>
                <input type="time" id="time" required>

                <label for="details">Medical Details:</label>
                <textarea id="details" rows="4" placeholder="Enter medical history details" required></textarea>

                <label for="file">Upload Medical Reports:</label>
                <input type="file" id="file" accept="application/pdf,image/*" multiple><br>

                <button type="submit">Add Medical History</button>
            </form>

            <div id="historyList" class="medical-history">
                <h2>History Entries</h2>
            </div>
        </div>
    </div>

    <script>
        // Simulated Database (In-memory storage)
        const patientDatabase = {
            "123": { name: "John Doe", password: "password123" },
            "456": { name: "Jane Smith", password: "password456" },
        };

        // Medical History Storage
        const medicalHistories = JSON.parse(localStorage.getItem('medicalHistories')) || {};

        const loginForm = document.getElementById('loginForm');
        const medicalHistoryContainer = document.getElementById('medicalHistoryContainer');
        const medicalHistoryForm = document.getElementById('medicalHistoryForm');
        const historyList = document.getElementById('historyList');

        loginForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent the form from refreshing the page

            const loginPatientID = document.getElementById('loginPatientID').value;
            const loginPassword = document.getElementById('loginPassword').value;

            // Check credentials
            if (patientDatabase[loginPatientID] && patientDatabase[loginPatientID].password === loginPassword) {
                alert('Login successful!');
                document.getElementById('patientName').value = patientDatabase[loginPatientID].name;
                medicalHistoryContainer.style.display = 'block';
                loadMedicalHistories(loginPatientID);
                loginForm.style.display = 'none';
            } else {
                alert('Invalid Patient ID or Password.');
            }
        });

        medicalHistoryForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent the form from refreshing the page

            const patientID = document.getElementById('loginPatientID').value; // Get the patient ID from login form
            const patientName = document.getElementById('patientName').value;
            const doctorName = document.getElementById('doctorName').value;
            const doctorID = document.getElementById('doctorID').value;
            const date = document.getElementById('date').value;
            const time = document.getElementById('time').value;
            const details = document.getElementById('details').value;
            const fileInput = document.getElementById('file');
            const files = fileInput.files;

            // Validation check for required fields
            if (!patientName || !doctorName || !doctorID || !date || !time || !details) {
                alert("Please fill in all the required fields.");
                return;
            }

            // Create a new medical history entry
            const entry = {
                patientName,
                doctorName,
                doctorID,
                date,
                time,
                details,
                files: Array.from(files).map(file => file.name), // Get the file names
            };

            // Save to local storage
            if (!medicalHistories[patientID]) {
                medicalHistories[patientID] = [];
            }
            medicalHistories[patientID].push(entry);
            localStorage.setItem('medicalHistories', JSON.stringify(medicalHistories));

            // Add entry to the UI
            addEntryToHistory(entry);
            medicalHistoryForm.reset();
        });

        function loadMedicalHistories(patientID) {
            const histories = medicalHistories[patientID] || [];
            histories.forEach(addEntryToHistory);
        }

        function addEntryToHistory(entry) {
            const historyEntry = document.createElement('div');
            historyEntry.classList.add('history-entry');
            let entryHTML = `
                <p><strong>Patient Name:</strong> ${entry.patientName}</p>
                <p><strong>Doctor's Name:</strong> ${entry.doctorName}</p>
                <p><strong>Doctor's ID:</strong> ${entry.doctorID}</p>
                <p><strong>Date:</strong> ${entry.date}</p>
                <p><strong>Time:</strong> ${entry.time}</p>
                <p><strong>Details:</strong> ${entry.details}</p>
            `;
            if (entry.files.length > 0) {
                entryHTML += `<p><strong>Uploaded Reports:</strong></p><ul>`;
                entry.files.forEach(file => {
                    entryHTML += `<li class="uploaded-file">${file}</li>`;
                });
                entryHTML += `</ul>`;
            }
            historyEntry.innerHTML = entryHTML;
            historyList.appendChild(historyEntry);
        }
    </script>
</body>
</html>

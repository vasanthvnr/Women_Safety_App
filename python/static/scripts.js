let lastVolumePressTime = 0;

// Listen for volume button presses
document.addEventListener('volumeup', handleVolumeButtonPress);
document.addEventListener('volumedown', handleVolumeButtonPress);

function handleVolumeButtonPress(e) {
    const currentTime = Date.now();
    if (currentTime - lastVolumePressTime < 500) {  // 500ms for double press detection
        triggerAlertProcess();
    }
    lastVolumePressTime = currentTime;
}

// Trigger the alert process when double press is detected
function triggerAlertProcess() {
    // Get live location using Geolocation API
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position) => {
            const location = `${position.coords.latitude}, ${position.coords.longitude}`;
            const userDetails = {
                name: "User", // You can fetch real details if available
                phone: "+1234567890", // Fetch phone number if available
                location: location
            };

            // Send the alert data to the backend
            sendAlertToBackend(userDetails);
        }, (error) => {
            console.error('Error getting location:', error);
        });
    } else {
        console.error('Geolocation is not supported by this browser.');
    }
}

// Send the alert details to the backend
function sendAlertToBackend(userDetails) {
    fetch('/alert', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(userDetails)
    })
    .then(response => response.json())
    .then(data => {
        if (data.alert) {
            console.log('Alert sent:', data.alert);
        } else {
            console.error('Error in sending alert:', data.error);
        }
    })
    .catch(error => console.error('Error:', error));
}

// Listen for new alerts from the server and update the table
const socket = io.connect('http://127.0.0.1:5000'); 

socket.on('new_alert', function(alert) {
    const buzzer = document.getElementById('buzzer-sound');
    if (buzzer) {
        buzzer.play().catch(error => console.error('Audio playback failed:', error));
    }

    const tableBody = document.getElementById('alerts-table-body');
    const row = document.createElement('tr');
    row.setAttribute('data-id', alert.id);

    row.innerHTML = `
        <td>${alert.id}</td>
        <td>${alert.name}</td>
        <td>${alert.phone}</td>
        <td>${alert.location}</td>
        <td style="color: ${alert.status === 'Pending' ? 'orange' : 'green'};">${alert.status}</td>
        <td>
            <button onclick="markResolved(${alert.id})">Mark Resolved</button>
        </td>
    `;
    tableBody.appendChild(row);
});

document.addEventListener('keydown', function(event) {
    if (event.key === '1') {
        window.location.href = '/user/1';
    }
});

// Mark an alert as resolved
function markResolved(alertId) {
    fetch(`/alert/${alertId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status: 'Resolved' })
    }).then(response => {
        if (response.ok) {
            const row = document.querySelector(`tr[data-id="${alertId}"]`);
            const statusCell = row.querySelector('td:nth-child(5)');
            statusCell.textContent = 'Resolved';
            statusCell.style.color = 'green';
            row.querySelector('button').remove();
        }
    });
}
let apiData = 'https://release.ofnur.com/portolia';
// const deployDate = 'Thu Aug 23 2024 10:51:46 GMT-0500 (Central Daylight Time)';
let deployDate = null;
let warningActivation = 8.64e+7;//millisecond
let warningDismissal = 8.64e+7;//millisecond
let message = `This website might be instability on $1, from $2 to $3 due to maintenance.`;

function showServerMessage(text) {
    let messageDiv = document.createElement('div');

    messageDiv.textContent = text;
    messageDiv.style.position = 'fixed';
    messageDiv.style.top = '0';
    messageDiv.style.left = '0';
    messageDiv.style.width = '100%';
    messageDiv.style.backgroundColor = '#FF9800'; // Semi-transparent red
    messageDiv.style.color = 'white';
    messageDiv.style.textAlign = 'center';
    messageDiv.style.padding = '6px 0';
    messageDiv.style.fontSize = '16px';
    messageDiv.style.zIndex = '1000';
    messageDiv.style.backdropFilter = 'blur(10px)';
    messageDiv.style.display = 'none';
    messageDiv.style.display = 'block'; // Initially display the message
    document.body.appendChild(messageDiv);

    setTimeout(() => {
        messageDiv.style.display = 'none';
    }, warningDismissal);
}

function getDateByIP() {
    fetch(apiData) // Replace with your actual API endpoint
        .then(response => response.text()) // Assuming response is plain text
        .then(dateText => {
            calculateDate(dateText);
        })
        .catch(error => {
            console.error('Error fetching the date:', error);
        });
}

const formatMaintenanceMessage = (releaseDate) => {
    if (!releaseDate) return '';
    const formattedDate = releaseDate.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
    });
    // Calculate end time (releaseDate + 1 hour)
    const endDate = new Date(releaseDate.getTime());
    endDate.setHours(releaseDate.getHours() + 1);

    // Format the maintenance window details
    const startTime = releaseDate.toLocaleTimeString('en-US', {hour: 'numeric', minute: '2-digit'});
    const endTime = endDate.toLocaleTimeString('en-US', {hour: 'numeric', minute: '2-digit'});
    return message
        .replace("$1", formattedDate)
        .replace("$2", startTime)
        .replace("$3", endTime);
};


function calculateDate(dateText) {
    const apiDate = new Date(dateText);
    const currentDate = new Date();
    const diffTime = apiDate - currentDate;
    if (diffTime > 0 && warningActivation >= diffTime) {
        showServerMessage(formatMaintenanceMessage(apiDate));
    }
}
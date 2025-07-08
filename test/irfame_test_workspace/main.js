// Listen for messages from the iframe
window.addEventListener('message', (event) => {
    // For security, check the origin
    if (event.origin !== 'http://localhost:5000') return;

    // Display the message on the page
    const logDiv = document.getElementById('message-log');
    const msgElem = document.createElement('div');
    msgElem.textContent = `Received: ${JSON.stringify(event.data)}`;
    logDiv.appendChild(msgElem);
});
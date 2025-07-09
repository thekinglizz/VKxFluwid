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

document.getElementById('sendBtn').addEventListener('click', function () {
    const message = {
        id: "1234567890",
        email: "example@test.com"
    };
    const iframe = document.getElementById('VKxFluwid-Frame');
    iframe.contentWindow.postMessage(message, "http://localhost:5000");
});
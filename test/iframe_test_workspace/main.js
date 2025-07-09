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

// Event on send 
function sendEmailId() {
    const message = {
        id: "1234567890",
        email: "example@test.com"
    };
    const iframe = document.getElementById('VKxFluwid-Frame');
    iframe.contentWindow.postMessage(message, "http://localhost:5000");
};

// Open \ Close IFrame button
const toggleBtn = document.getElementById('iframe-toggle-btn');
const container = document.getElementById('iframe-container');
let iframeOpen = false;
let sendBtn = null;
let iframe = null;
toggleBtn.addEventListener('click', () => {
    if (!iframeOpen) {
        // Create send button
        sendBtn = document.createElement('button');
        sendBtn.id = 'sendBtn';
        sendBtn.textContent = 'Send email and id to IFrame';
        sendBtn.style.marginTop = '10px';
        container.appendChild(sendBtn);

        // Create iframe
        iframe = document.createElement('iframe');
        iframe.id = 'VKxFluwid-Frame';
        iframe.src = 'http://localhost:5000/?id=1333&actionEventId=7408&cityId=3&zone=test';
        iframe.width = '900';
        iframe.height = '600';
        iframe.style.marginTop = '10px';
        iframe.style.border = '1px solid #ccc';
        container.appendChild(iframe);

        // Attach event listener for sendBtn
        sendBtn.addEventListener('click', function () {
            sendEmailId();
        });
        toggleBtn.textContent = 'Close Iframe';
        iframeOpen = true;
    } else {
        // Remove iframe and send button
        if (iframe) container.removeChild(iframe);
        if (sendBtn) container.removeChild(sendBtn);
        toggleBtn.textContent = 'Open Iframe';
        iframeOpen = false;
    }
});
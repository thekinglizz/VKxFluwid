import * as Consts from './scripts/consts.js';
import * as Url from './scripts/url.js';

// Listen for messages from the iframe
window.addEventListener('message', (event) => {
    // For security, check the origin
    if (event.origin !== Url.origin) return;

    // Display the message on the page
    const logDiv = document.getElementById('message-log');
    const msgElem = document.createElement('div');
    msgElem.textContent = `Received: ${JSON.stringify(event.data)}`;
    logDiv.appendChild(msgElem);
});

// Event on send 
function sendEmailId() {
    const iframe = document.getElementById('VKxFluwid-Frame');
    iframe.contentWindow.postMessage(Consts.peronalizedMessage, Url.origin);
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
        sendBtn.textContent = 'Send "Personalized" event to IFrame';
        sendBtn.style.marginTop = '10px';
        container.appendChild(sendBtn);

        // Create iframe
        iframe = document.createElement('iframe');
        iframe.id = 'VKxFluwid-Frame';
        iframe.src = Url.getUrl();
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
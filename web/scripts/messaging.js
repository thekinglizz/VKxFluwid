// Listen for messages from the parent window (when running in an iframe)
// window.addEventListener('message', handleParentMessage);

// Partner widget methods
window.sendMessageFromDart = function (message, origin) {
    window.parent.postMessage(message, origin);
};
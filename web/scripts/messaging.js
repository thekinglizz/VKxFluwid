// Listen for messages from the parent window (when running in an iframe)
window.addEventListener("message", function (event) {
    if (window.postMessageFromJS) {
        window.postMessageFromJS(event.data, event.origin);
    }
});

// Partner widget methods
window.sendMessageFromDart = function (message, origin) {
    try {
        window.parent.postMessage(JSON.parse(message), origin);
        return;
    } catch (error) {
        console.log('Error on postMessage:\n', error);
    }
};
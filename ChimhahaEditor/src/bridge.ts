type MessageType = 'ready' | 'submit' | 'requestImagePicker';

interface SubmitPayload {
    title: string;
    body: string;
    poll?: {
        title: string;
        options: string[];
    };
}

interface BridgeMessage {
    type: MessageType;
    payload?: SubmitPayload;
}

function postToSwift(message: BridgeMessage) {
    const webkit = (window as any).webkit;
    if (webkit?.messageHandlers?.chimEditor) {
        webkit.messageHandlers.chimEditor.postMessage(message);
    }
}

export function notifyReady() {
    postToSwift({ type: 'ready' });
}

export function submitContent(payload: SubmitPayload) {
    postToSwift({ type: 'submit', payload });
}

export function requestImagePicker() {
    postToSwift({ type: 'requestImagePicker' });
}
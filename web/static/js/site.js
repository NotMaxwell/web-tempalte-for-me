"use strict";
// Site TypeScript (compiled to web/static/js/site.js)
// Keep business logic on the server; this file is for UI polish only.
// Log when HTMX makes requests (useful for debugging)
document.body.addEventListener('htmx:beforeRequest', (event) => {
    try {
        console.debug('HTMX Request:', event.detail?.pathInfo?.requestPath);
    }
    catch (e) {
        console.debug('HTMX Request (no detail)');
    }
});
// Handle HTMX errors
document.body.addEventListener('htmx:responseError', (event) => {
    try {
        console.error('HTMX Error:', event.detail.xhr.status, event.detail.xhr.statusText);
        // TODO: Show user-friendly error message
    }
    catch (e) {
        console.error('HTMX Error: unknown');
    }
});
// Simple toast notification helper (global function)
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} fixed bottom-4 right-4 z-50`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}
// Expose to window for inline script access
window.showToast = showToast;

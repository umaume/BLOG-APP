// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Global utility functions
window.copyToClipboard = function (text) {
    navigator.clipboard.writeText(text).then(function () {
        // Show a toast notification
        const toast = document.createElement('div')
        toast.className = 'fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded-md shadow-lg z-50'
        toast.textContent = 'URLをクリップボードにコピーしました'
        document.body.appendChild(toast)

        setTimeout(() => {
            toast.remove()
        }, 3000)
    }).catch(function (err) {
        console.error('Could not copy text: ', err)
    })
}

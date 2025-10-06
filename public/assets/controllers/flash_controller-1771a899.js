import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { timeout: Number }

    connect() {
        // Show the message with animation
        this.showMessage()

        // Auto-dismiss after timeout
        if (this.timeoutValue > 0) {
            this.timeoutId = setTimeout(() => {
                this.dismiss()
            }, this.timeoutValue)
        }
    }

    disconnect() {
        if (this.timeoutId) {
            clearTimeout(this.timeoutId)
        }
    }

    showMessage() {
        // Animate in
        requestAnimationFrame(() => {
            this.element.classList.remove("translate-x-full", "opacity-0")
            this.element.classList.add("translate-x-0", "opacity-100")
        })
    }

    dismiss() {
        // Animate out
        this.element.classList.add("translate-x-full", "opacity-0")
        this.element.classList.remove("translate-x-0", "opacity-100")

        // Remove element after animation
        setTimeout(() => {
            if (this.element.parentNode) {
                this.element.remove()
            }
        }, 500)
    }
}
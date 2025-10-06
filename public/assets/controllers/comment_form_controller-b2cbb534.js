import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["textarea", "counter", "submit"]

    connect() {
        this.updateCounter()
        this.addKeyboardShortcuts()
    }

    updateCounter() {
        const textarea = this.textareaTarget
        const counter = this.counterTarget
        const maxLength = 500

        const currentLength = textarea.value.length
        counter.textContent = `${currentLength}/${maxLength}`

        // Update counter color based on length
        if (currentLength > maxLength * 0.8) {
            counter.classList.add("text-red-500")
            counter.classList.remove("text-gray-500", "text-yellow-500")
        } else if (currentLength > maxLength * 0.6) {
            counter.classList.add("text-yellow-500")
            counter.classList.remove("text-gray-500", "text-red-500")
        } else {
            counter.classList.add("text-gray-500")
            counter.classList.remove("text-red-500", "text-yellow-500")
        }

        // Disable submit if over limit
        const submitButton = this.submitTarget
        if (currentLength > maxLength || currentLength === 0) {
            submitButton.disabled = true
            submitButton.classList.add("opacity-50", "cursor-not-allowed")
        } else {
            submitButton.disabled = false
            submitButton.classList.remove("opacity-50", "cursor-not-allowed")
        }
    }

    addKeyboardShortcuts() {
        const textarea = this.textareaTarget

        textarea.addEventListener("keydown", (event) => {
            // Ctrl+Enter to submit
            if ((event.ctrlKey || event.metaKey) && event.key === "Enter") {
                event.preventDefault()
                if (!this.submitTarget.disabled) {
                    this.submitTarget.click()
                }
            }

            // Tab to indent (optional enhancement)
            if (event.key === "Tab") {
                event.preventDefault()
                const start = textarea.selectionStart
                const end = textarea.selectionEnd

                textarea.value = textarea.value.substring(0, start) + "  " + textarea.value.substring(end)
                textarea.selectionStart = textarea.selectionEnd = start + 2
                this.updateCounter()
            }
        })
    }

    // Auto-resize textarea
    autoResize(event) {
        const textarea = event.target
        textarea.style.height = 'auto'
        textarea.style.height = textarea.scrollHeight + 'px'
    }

    // Focus management
    focus() {
        this.textareaTarget.focus()
    }

    // Clear form
    clear() {
        this.textareaTarget.value = ""
        this.updateCounter()
        this.textareaTarget.style.height = 'auto'
    }
}
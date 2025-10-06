import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile-menu"
export default class extends Controller {
    static targets = ["menu", "button", "overlay"]
    static classes = ["open"]

    connect() {
        this.isOpen = false
    }

    toggle() {
        if (this.isOpen) {
            this.close()
        } else {
            this.open()
        }
    }

    open() {
        this.isOpen = true
        this.menuTarget.classList.remove("hidden")
        this.menuTarget.classList.add("block")
        this.overlayTarget.classList.remove("hidden")
        document.body.classList.add("overflow-hidden")

        // Update button appearance
        this.updateButtonIcon()
    }

    close() {
        this.isOpen = false
        this.menuTarget.classList.remove("block")
        this.menuTarget.classList.add("hidden")
        this.overlayTarget.classList.add("hidden")
        document.body.classList.remove("overflow-hidden")

        // Update button appearance
        this.updateButtonIcon()
    }

    overlayClick(event) {
        if (event.target === this.overlayTarget) {
            this.close()
        }
    }

    updateButtonIcon() {
        const hamburgerIcon = this.buttonTarget.querySelector('.hamburger-icon')
        const closeIcon = this.buttonTarget.querySelector('.close-icon')

        if (this.isOpen) {
            hamburgerIcon.classList.add('hidden')
            closeIcon.classList.remove('hidden')
        } else {
            hamburgerIcon.classList.remove('hidden')
            closeIcon.classList.add('hidden')
        }
    }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.showLoadingOnNavigate()
    }

    showLoadingOnNavigate() {
        document.addEventListener("turbo:click", this.showLoading.bind(this))
        document.addEventListener("turbo:submit-start", this.showLoading.bind(this))
        document.addEventListener("turbo:render", this.hideLoading.bind(this))
        document.addEventListener("turbo:load", this.hideLoading.bind(this))
    }

    showLoading() {
        this.createLoadingIndicator()
    }

    hideLoading() {
        this.removeLoadingIndicator()
    }

    createLoadingIndicator() {
        // Remove existing loading indicator
        this.removeLoadingIndicator()

        const loading = document.createElement('div')
        loading.id = 'loading-indicator'
        loading.className = 'fixed top-0 left-0 w-full z-50'
        loading.innerHTML = `
      <div class="bg-blue-600 h-1 transition-all duration-300 ease-out" style="width: 0%"></div>
    `

        document.body.appendChild(loading)

        // Animate the progress bar
        setTimeout(() => {
            const bar = loading.querySelector('div')
            bar.style.width = '30%'

            setTimeout(() => {
                bar.style.width = '60%'
            }, 200)

            setTimeout(() => {
                bar.style.width = '80%'
            }, 400)
        }, 50)
    }

    removeLoadingIndicator() {
        const existing = document.getElementById('loading-indicator')
        if (existing) {
            const bar = existing.querySelector('div')
            if (bar) {
                bar.style.width = '100%'
                setTimeout(() => {
                    existing.remove()
                }, 200)
            } else {
                existing.remove()
            }
        }
    }

    disconnect() {
        document.removeEventListener("turbo:click", this.showLoading)
        document.removeEventListener("turbo:submit-start", this.showLoading)
        document.removeEventListener("turbo:render", this.hideLoading)
        document.removeEventListener("turbo:load", this.hideLoading)
    }
}
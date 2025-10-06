import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-preview"
export default class extends Controller {
    static targets = ["input", "preview", "container", "current", "placeholder"]

    preview(event) {
        const input = event.target
        const file = input.files[0]

        if (file) {
            const reader = new FileReader()

            reader.onload = (e) => {
                const previewImg = document.getElementById('avatar-preview')
                const previewContainer = document.getElementById('avatar-preview-container')

                if (previewImg && previewContainer) {
                    previewImg.src = e.target.result
                    previewImg.style.display = 'block'
                    previewContainer.style.display = 'block'
                }
            }

            reader.readAsDataURL(file)
        }
    }
}
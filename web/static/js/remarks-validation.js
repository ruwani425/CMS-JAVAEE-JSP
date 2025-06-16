function validateRemarksCharacters(complaintId) {
    const remarksField = document.getElementById(`remarks${complaintId}`)
    const remarksValue = remarksField.value.trim()
    const errorSpan = document.getElementById(`remarksError${complaintId}`)
    const charCount = remarksValue.length

    let isValid = true
    let errorMessage = ""

    remarksField.classList.remove("is-invalid", "is-valid")
    errorSpan.textContent = ""
    errorSpan.style.display = "none"

    if (charCount > 0 && charCount < 10) {
        errorMessage = "Remarks must be at least 10 characters long."
        isValid = false
    } else if (charCount > 500) {
        errorMessage = "Remarks cannot exceed 500 characters."
        isValid = false
    }

    if (!isValid) {
        remarksField.classList.add("is-invalid")
        errorSpan.textContent = errorMessage
        errorSpan.style.display = "block"
    } else if (charCount > 0) {
        remarksField.classList.add("is-valid")
    }

    return isValid
}

function updateCharacterCounter(complaintId) {
    const remarksField = document.getElementById(`remarks${complaintId}`)
    const counterSpan = document.getElementById(`charCounter${complaintId}`)
    const currentLength = remarksField.value.length
    const maxLength = 500

    counterSpan.textContent = `${currentLength}/${maxLength} characters`

    if (currentLength < 10 && currentLength > 0) {
        counterSpan.className = "form-text text-danger"
    } else if (currentLength > 400) {
        counterSpan.className = "form-text text-warning"
    } else if (currentLength >= 10) {
        counterSpan.className = "form-text text-success"
    } else {
        counterSpan.className = "form-text text-muted"
    }
}

function submitRemarksForm(complaintId) {
    const remarksField = document.getElementById(`remarks${complaintId}`)

    if (!remarksField.checkValidity()) {
        remarksField.reportValidity()
        return false
    }

    const isValid = validateRemarksCharacters(complaintId)

    if (isValid) {
        const submitBtn = document.querySelector(`#remarksModal${complaintId} .btn-warning`)
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Adding Remarks...'
        submitBtn.disabled = true

        document.getElementById(`remarksForm${complaintId}`).submit()
    }

    return isValid
}

document.addEventListener("DOMContentLoaded", () => {
    const remarksTextareas = document.querySelectorAll('textarea[id^="remarks"]')

    remarksTextareas.forEach((textarea) => {
        const complaintId = textarea.id.replace("remarks", "")

        updateCharacterCounter(complaintId)

        textarea.addEventListener("input", () => {
            updateCharacterCounter(complaintId)
            validateRemarksCharacters(complaintId)
        })

        textarea.addEventListener("blur", () => {
            validateRemarksCharacters(complaintId)
        })
    })

    document.addEventListener("hidden.bs.modal", (event) => {
        const modal = event.target
        if (modal.id.startsWith("remarksModal")) {
            const complaintId = modal.id.replace("remarksModal", "")

            const form = document.getElementById(`remarksForm${complaintId}`)
            if (form) {
                form.reset()
            }

            const remarksField = document.getElementById(`remarks${complaintId}`)
            const errorSpan = document.getElementById(`remarksError${complaintId}`)
            const counterSpan = document.getElementById(`charCounter${complaintId}`)

            if (remarksField) {
                remarksField.classList.remove("is-invalid", "is-valid")
            }
            if (errorSpan) {
                errorSpan.textContent = ""
                errorSpan.style.display = "none"
            }
            if (counterSpan) {
                counterSpan.textContent = "0/500 characters"
                counterSpan.className = "form-text text-muted"
            }

            const submitBtn = modal.querySelector(".btn-warning")
            if (submitBtn) {
                submitBtn.innerHTML = '<i class="bi bi-check-circle"></i> Add Remarks'
                submitBtn.disabled = false
            }
        }
    })
})

window.submitRemarksForm = submitRemarksForm

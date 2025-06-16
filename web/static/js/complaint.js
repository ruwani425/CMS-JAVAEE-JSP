function validateComplaintField(fieldId, fieldName) {
    const field = document.getElementById(fieldId)
    const value = field.value.trim()
    const errorSpanId = fieldId + "Error"
    let errorSpan = document.getElementById(errorSpanId)

    if (!errorSpan) {
        errorSpan = document.createElement("span")
        errorSpan.id = errorSpanId
        errorSpan.className = "error-message"
        field.closest(".mb-3").appendChild(errorSpan)
    }

    let isValid = true
    let errorMessage = ""

    field.classList.remove("error-input")
    errorSpan.textContent = ""

    switch (fieldName) {
        case "title":
            if (value.length > 0 && value.length < 5) {
                errorMessage = "Complaint title must be at least 5 characters."
                isValid = false
            } else if (value.length > 100) {
                errorMessage = "Complaint title must not exceed 100 characters."
                isValid = false
            }
            break

        case "category":
        case "priority":
            break

        case "description":
            if (value.length > 0 && value.length < 10) {
                errorMessage = "Description must be at least 10 characters."
                isValid = false
            } else if (value.length > 1000) {
                errorMessage = "Description must not exceed 1000 characters."
                isValid = false
            }
            break
    }

    if (!isValid) {
        field.classList.add("error-input")
        errorSpan.textContent = errorMessage

        const inputGroup = field.closest(".input-group")
        if (inputGroup) {
            inputGroup.classList.add("error-input-group")
        }
    } else {
        const inputGroup = field.closest(".input-group")
        if (inputGroup) {
            inputGroup.classList.remove("error-input-group")
        }
    }

    return isValid
}

function validateNewComplaintForm() {
    const form = document.getElementById("complaintForm")

    if (!form.checkValidity()) {
        form.reportValidity()
        return false
    }

    const fields = [
        {id: "complaintTitle", name: "title"},
        {id: "complaintCategory", name: "category"},
        {id: "complaintPriority", name: "priority"},
        {id: "complaintDescription", name: "description"},
    ]

    let isFormValid = true

    fields.forEach((field) => {
        if (!validateComplaintField(field.id, field.name)) {
            isFormValid = false
        }
    })

    if (isFormValid) {
        const submitBtn = document.querySelector("#newComplaintModal .btn-primary")
        const originalText = submitBtn.innerHTML
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Submitting...'
        submitBtn.disabled = true

        document.getElementById("complaintForm").submit()
    } else {
        const firstError = document.querySelector("#newComplaintModal .error-input")
        if (firstError) {
            firstError.scrollIntoView({behavior: "smooth", block: "center"})
            firstError.focus()
        }
    }

    return isFormValid
}

function validateUpdateComplaintForm(complaintId) {
    const form = document.getElementById(`updateComplaintForm${complaintId}`)

    if (!form.checkValidity()) {
        form.reportValidity()
        return false
    }

    const fields = [
        {id: `updateComplaintTitle${complaintId}`, name: "title"},
        {id: `updateComplaintCategory${complaintId}`, name: "category"},
        {id: `updateComplaintPriority${complaintId}`, name: "priority"},
        {id: `updateComplaintDescription${complaintId}`, name: "description"},
    ]

    let isFormValid = true

    fields.forEach((field) => {
        if (!validateComplaintField(field.id, field.name)) {
            isFormValid = false
        }
    })

    if (isFormValid) {
        const submitBtn = document.querySelector(`#updateComplaintModal${complaintId} .btn-primary`)
        const originalText = submitBtn.innerHTML
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Updating...'
        submitBtn.disabled = true

        document.getElementById(`updateComplaintForm${complaintId}`).submit()
    } else {
        const firstError = document.querySelector(`#updateComplaintModal${complaintId} .error-input`)
        if (firstError) {
            firstError.scrollIntoView({behavior: "smooth", block: "center"})
            firstError.focus()
        }
    }

    return isFormValid
}

function updateCharacterCount(textareaId, maxLength = 1000) {
    const textarea = document.getElementById(textareaId)
    const currentLength = textarea.value.length

    const counterId = textareaId + "Counter"
    let counter = document.getElementById(counterId)

    if (!counter) {
        counter = document.createElement("small")
        counter.id = counterId
        counter.className = "character-counter"
        textarea.closest(".mb-3").appendChild(counter)
    }

    counter.textContent = `${currentLength}/${maxLength} characters`

    if (currentLength > maxLength * 0.9) {
        counter.classList.add("text-warning")
    } else {
        counter.classList.remove("text-warning")
    }

    if (currentLength > maxLength) {
        counter.classList.add("text-danger")
        counter.classList.remove("text-warning")
    } else {
        counter.classList.remove("text-danger")
    }
}

function setupRealTimeValidation() {
    const newComplaintFields = [
        {id: "complaintTitle", name: "title"},
        {id: "complaintCategory", name: "category"},
        {id: "complaintPriority", name: "priority"},
        {id: "complaintDescription", name: "description"},
    ]

    newComplaintFields.forEach((field) => {
        const element = document.getElementById(field.id)
        if (element) {
            element.addEventListener("blur", () => {
                validateComplaintField(field.id, field.name)
            })

            element.addEventListener("input", function () {
                if (this.classList.contains("error-input")) {
                    this.classList.remove("error-input")
                    const errorSpan = document.getElementById(this.id + "Error")
                    if (errorSpan) {
                        errorSpan.textContent = ""
                    }

                    const inputGroup = this.closest(".input-group")
                    if (inputGroup) {
                        inputGroup.classList.remove("error-input-group")
                    }
                }

                if (field.name === "description") {
                    updateCharacterCount(field.id)
                }
            })
        }
    })

    document.addEventListener("shown.bs.modal", (event) => {
        const modal = event.target
        if (modal.id.startsWith("updateComplaintModal")) {
            const complaintId = modal.id.replace("updateComplaintModal", "")

            const updateFields = [
                {id: `updateComplaintTitle${complaintId}`, name: "title"},
                {id: `updateComplaintCategory${complaintId}`, name: "category"},
                {id: `updateComplaintPriority${complaintId}`, name: "priority"},
                {id: `updateComplaintDescription${complaintId}`, name: "description"},
            ]

            updateFields.forEach((field) => {
                const element = document.getElementById(field.id)
                if (element) {
                    element.removeEventListener("blur", handleBlur)
                    element.removeEventListener("input", handleInput)

                    element.addEventListener("blur", handleBlur)

                    element.addEventListener("input", handleInput)
                }
            })
        }
    })
}

function handleBlur(event) {
    const fieldId = event.target.id
    let fieldName = ""

    if (fieldId.includes("Title")) fieldName = "title"
    else if (fieldId.includes("Category")) fieldName = "category"
    else if (fieldId.includes("Priority")) fieldName = "priority"
    else if (fieldId.includes("Description")) fieldName = "description"

    if (fieldName) {
        validateComplaintField(fieldId, fieldName)
    }
}

function handleInput(event) {
    const element = event.target

    if (element.classList.contains("error-input")) {
        element.classList.remove("error-input")
        const errorSpan = document.getElementById(element.id + "Error")
        if (errorSpan) {
            errorSpan.textContent = ""
        }

        const inputGroup = element.closest(".input-group")
        if (inputGroup) {
            inputGroup.classList.remove("error-input-group")
        }
    }

    if (element.id.includes("Description")) {
        updateCharacterCount(element.id)
    }
}

function resetNewComplaintForm() {
    const form = document.getElementById("complaintForm")
    if (form) {
        form.reset()

        const errorMessages = form.querySelectorAll(".error-message")
        errorMessages.forEach((error) => (error.textContent = ""))

        const errorInputs = form.querySelectorAll(".error-input")
        errorInputs.forEach((input) => input.classList.remove("error-input"))

        const errorInputGroups = form.querySelectorAll(".error-input-group")
        errorInputGroups.forEach((group) => group.classList.remove("error-input-group"))

        const counters = form.querySelectorAll(".character-counter")
        counters.forEach((counter) => (counter.textContent = "0/1000 characters"))
    }
}

function resetUpdateComplaintForm(complaintId) {
    const form = document.getElementById(`updateComplaintForm${complaintId}`)
    if (form) {
        const errorMessages = form.querySelectorAll(".error-message")
        errorMessages.forEach((error) => (error.textContent = ""))

        const errorInputs = form.querySelectorAll(".error-input")
        errorInputs.forEach((input) => input.classList.remove("error-input"))

        const errorInputGroups = form.querySelectorAll(".error-input-group")
        errorInputGroups.forEach((group) => group.classList.remove("error-input-group"))
    }
}

document.addEventListener("DOMContentLoaded", () => {
    setupRealTimeValidation()

    const descriptionField = document.getElementById("complaintDescription")
    if (descriptionField) {
        updateCharacterCount("complaintDescription")
    }

    document.addEventListener("hidden.bs.modal", (event) => {
        const modal = event.target
        if (modal.id === "newComplaintModal") {
            resetNewComplaintForm()
        } else if (modal.id.startsWith("updateComplaintModal")) {
            const complaintId = modal.id.replace("updateComplaintModal", "")
            resetUpdateComplaintForm(complaintId)
        }
    })
})
document.getElementById('status').addEventListener('change', function () {
    const status = this.value;
    const remarksField = document.getElementById('adminRemarks');

    if (status === 'RESOLVED' && remarksField.value.trim() === '') {
        remarksField.placeholder = 'Please describe how the complaint was resolved...';
    } else if (status === 'REJECTED' && remarksField.value.trim() === '') {
        remarksField.placeholder = 'Please provide reason for rejection...';
    } else if (status === 'IN_PROGRESS' && remarksField.value.trim() === '') {
        remarksField.placeholder = 'Please describe current progress and next steps...';
    }
});

document.querySelector('form').addEventListener('submit', function (e) {
    const status = document.getElementById('status').value;
    const remarks = document.getElementById('adminRemarks').value.trim();

    if ((status === 'RESOLVED' || status === 'REJECTED') && remarks === '') {
        e.preventDefault();
        alert('Please add remarks when marking a complaint as ' + status.toLowerCase() + '.');
        document.getElementById('adminRemarks').focus();
        return false;
    }

    return confirm('Are you sure you want to update this complaint status to ' + status.replace('_', ' ') + '?');
});
window.validateNewComplaintForm = validateNewComplaintForm
window.validateUpdateComplaintForm = validateUpdateComplaintForm

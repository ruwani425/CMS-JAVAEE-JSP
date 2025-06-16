function validateField(fieldName) {
    const field = document.getElementById(fieldName)
    const value = field.value.trim()
    const errorSpan = document.getElementById(fieldName + "Error")

    let isValid = true
    let errorMessage = ""

    field.classList.remove("error-input")
    errorSpan.textContent = ""

    switch (fieldName) {
        case "fullName":
            if (value.length > 0 && value.length < 3) {
                errorMessage = "Full name must be at least 3 characters."
                isValid = false
            }
            break

        case "email":
            if (value.length > 0) {
                const emailPattern = /^[^\s]+@[^\s]+\.[a-z]{2,3}$/i
                if (!emailPattern.test(value)) {
                    errorMessage = "Please enter a valid email address."
                    isValid = false
                }
            }
            break

        case "username":
            if (value.length > 0) {
                if (value.length < 4) {
                    errorMessage = "Username must be at least 4 characters."
                    isValid = false
                } else if (!/^[a-zA-Z0-9_]+$/.test(value)) {
                    errorMessage = "Username can only contain letters, numbers, and underscores."
                    isValid = false
                }
            }
            break

        case "password":
            if (value.length > 0) {
                const passwordErrors = validatePassword(value)
                if (passwordErrors.length > 0) {
                    errorMessage = passwordErrors[0]
                    isValid = false
                }
            }
            break
    }

    if (!isValid) {
        field.classList.add("error-input")
        errorSpan.textContent = errorMessage
    }

    return isValid
}

function validatePassword(password) {
    const errors = []

    if (password.length < 8) {
        errors.push("Password must be at least 8 characters.")
    }
    if (!/(?=.*[a-z])/.test(password)) {
        errors.push("Password must contain at least one lowercase letter.")
    }
    if (!/(?=.*[A-Z])/.test(password)) {
        errors.push("Password must contain at least one uppercase letter.")
    }
    if (!/(?=.*\d)/.test(password)) {
        errors.push("Password must contain at least one number.")
    }
    if (!/(?=.*[@$!%*?&])/.test(password)) {
        errors.push("Password must contain at least one special character (@$!%*?&).")
    }

    return errors
}

function getPasswordStrength(password) {
    if (password.length === 0) return {strength: "", score: 0}

    let score = 0
    if (password.length >= 8) score++
    if (/(?=.*[a-z])/.test(password)) score++
    if (/(?=.*[A-Z])/.test(password)) score++
    if (/(?=.*\d)/.test(password)) score++
    if (/(?=.*[@$!%*?&])/.test(password)) score++

    if (score < 2) return {strength: "Weak", score: score, class: "weak"}
    if (score < 4) return {strength: "Medium", score: score, class: "medium"}
    return {strength: "Strong", score: score, class: "strong"}
}

function showPasswordStrength() {
    const password = document.getElementById("password").value
    const strengthDiv = document.getElementById("passwordStrength")

    if (password.length === 0) {
        strengthDiv.innerHTML = ""
        return
    }

    const strength = getPasswordStrength(password)
    const errors = validatePassword(password)

    let strengthHTML = `
        <div class="strength-indicator">
            <div class="strength-text ${strength.class}">
                <i class="bi bi-shield-${strength.class === "strong" ? "check" : strength.class === "medium" ? "exclamation" : "x"}"></i>
                Password Strength: ${strength.strength}
            </div>
            <div class="strength-bars">
    `

    for (let i = 1; i <= 5; i++) {
        strengthHTML += `<div class="strength-bar ${i <= strength.score ? strength.class : ""}"></div>`
    }

    strengthHTML += "</div></div>"

    if (errors.length > 0) {
        strengthHTML += '<div class="password-requirements"><small>Requirements:</small><ul>'
        errors.forEach((error) => {
            strengthHTML += `<li class="requirement-error">${error}</li>`
        })
        strengthHTML += "</ul></div>"
    }

    strengthDiv.innerHTML = strengthHTML
}

function validateForm() {
    const form = document.getElementById("signupForm")

    if (!form.checkValidity()) {
        form.reportValidity()
        return false
    }

    const fields = ["fullName", "email", "username", "password"]
    let isFormValid = true

    fields.forEach((field) => {
        if (!validateField(field)) {
            isFormValid = false
        }
    })

    if (isFormValid) {
        document.getElementById("signupForm").submit()
    } else {
        const firstError = document.querySelector(".error-input")
        if (firstError) {
            firstError.scrollIntoView({behavior: "smooth", block: "center"})
            firstError.focus()
        }
    }
}

function togglePasswordVisibility() {
    const passwordInput = document.getElementById("password");
    const icon = document.getElementById("togglePasswordIcon");

    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    } else {
        passwordInput.type = "password";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    }
}


document.addEventListener("DOMContentLoaded", () => {
    const inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]')

    inputs.forEach((input) => {
        input.addEventListener("input", function () {
            if (this.classList.contains("error-input")) {
                this.classList.remove("error-input")
                const errorSpan = document.getElementById(this.id + "Error")
                if (errorSpan) {
                    errorSpan.textContent = ""
                }
            }
        })
    })
})

// GAS Web App URL Placeholder
const GAS_URL = "ここにGASのWebアプリURLを設定";

// LocalStorage Key
const STORAGE_KEY = "upaid_hearing_form_draft";

document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("hearingForm");
    const progressFill = document.getElementById("progress-fill");
    const progressText = document.getElementById("progress-text");
    const loadingOverlay = document.getElementById("loadingOverlay");
    const submitBtn = document.getElementById("submitBtn");
    const successMessage = document.getElementById("successMessage");

    // List of required groups/fields to calculate progress
    const requiredFields = [
        { name: "company_name", type: "text" },
        { name: "manager_name", type: "text" },
        { name: "phone", type: "tel" },
        { name: "email", type: "email" },
        { name: "site_purpose", type: "radio" },
        { name: "plan", type: "radio" },
        { name: "final_goal", type: "radio" },
        { name: "deadline", type: "radio" }
    ];

    // Initialize/Restore Form Data
    restoreDraft();
    updateActiveOptionControls();
    toggleConditionalFields();
    updateProgress();

    // Event listener for auto-save and active styling on change
    form.addEventListener("input", () => {
        saveDraft();
        updateProgress();
    });

    form.addEventListener("change", (e) => {
        saveDraft();
        updateActiveOptionControls();
        toggleConditionalFields();
        updateProgress();
    });

    // Checkbox/Radio Option Highlight helper
    function updateActiveOptionControls() {
        const controls = document.querySelectorAll(".option-control");
        controls.forEach(control => {
            const input = control.querySelector("input");
            if (input && input.checked) {
                control.classList.add("active");
            } else {
                control.classList.remove("active");
            }
        });
    }

    // Toggle Conditional Input Visibility
    function toggleConditionalFields() {
        // Purpose Other
        const purposeOtherRadio = document.getElementById("purpose_other_radio");
        const purposeOtherContainer = document.getElementById("purpose_other_container");
        if (purposeOtherRadio && purposeOtherRadio.checked) {
            purposeOtherContainer.classList.add("show");
        } else {
            purposeOtherContainer.classList.remove("show");
        }

        // Vibe Other
        const vibeOtherCheckbox = document.getElementById("vibe_other_checkbox");
        const vibeOtherContainer = document.getElementById("vibe_other_container");
        if (vibeOtherCheckbox && vibeOtherCheckbox.checked) {
            vibeOtherContainer.classList.add("show");
        } else {
            vibeOtherContainer.classList.remove("show");
        }

        // Current Domain Yes
        const domainCurrentYes = document.getElementById("domain_current_yes");
        const domainCurrentContainer = document.getElementById("domain_current_container");
        if (domainCurrentYes && domainCurrentYes.checked) {
            domainCurrentContainer.classList.add("show");
        } else {
            domainCurrentContainer.classList.remove("show");
        }

        // Goal Other
        const finalGoalOtherRadio = document.getElementById("final_goal_other_radio");
        const finalGoalOtherContainer = document.getElementById("final_goal_other_container");
        if (finalGoalOtherRadio && finalGoalOtherRadio.checked) {
            finalGoalOtherContainer.classList.add("show");
        } else {
            finalGoalOtherContainer.classList.remove("show");
        }

        // Toggle Section Texts Textareas dynamically based on checklist
        const sectionCheckboxes = [
            { id: "sec_hero", checkbox: "sec_hero_show" },
            { id: "sec_news", checkbox: "sec_news_show" },
            { id: "sec_profile", checkbox: "sec_profile_show" },
            { id: "sec_business", checkbox: "sec_business_show" },
            { id: "sec_greeting", checkbox: "sec_greeting_show" },
            { id: "sec_service", checkbox: "sec_service_show" },
            { id: "sec_products", checkbox: "sec_products_show" },
            { id: "sec_map", checkbox: "sec_map_show" },
            { id: "sec_access", checkbox: "sec_access_show" },
            { id: "sec_contact", checkbox: "sec_contact_show" }
        ];

        sectionCheckboxes.forEach(item => {
            const cb = document.querySelector(`input[name="${item.checkbox}"]`);
            const container = document.getElementById(`${item.id}_text_container`);
            if (cb && container) {
                if (cb.checked) {
                    container.classList.add("show");
                } else {
                    container.classList.remove("show");
                }
            }
        });

        // Other Section Text dynamic visibility and label
        const secOtherInput = document.getElementById("sec_other");
        const secOtherTextContainer = document.getElementById("sec_other_text_container");
        const secOtherTextLabel = document.getElementById("sec_other_text_label");
        if (secOtherInput && secOtherTextContainer) {
            const val = secOtherInput.value.trim();
            if (val !== "") {
                secOtherTextContainer.classList.add("show");
                if (secOtherTextLabel) {
                    secOtherTextLabel.textContent = `「${val}」に掲載したい文章`;
                }
            } else {
                secOtherTextContainer.classList.remove("show");
            }
        }
    }

    // Calculate progress based on filled required fields
    function updateProgress() {
        let filledCount = 0;

        requiredFields.forEach(field => {
            if (field.type === "radio") {
                const radios = document.getElementsByName(field.name);
                const isChecked = Array.from(radios).some(r => r.checked);
                if (isChecked) filledCount++;
            } else {
                const el = document.getElementById(field.name);
                if (el && el.value.trim() !== "") {
                    filledCount++;
                }
            }
        });

        const percent = Math.round((filledCount / requiredFields.length) * 100);
        progressFill.style.width = `${percent}%`;
        progressText.textContent = `${percent}%`;
    }

    // Save form data to LocalStorage
    function saveDraft() {
        const formData = new FormData(form);
        const data = {};

        for (const [key, value] of formData.entries()) {
            // Checkbox multi-select handling
            if (key === "design_color" || key === "design_vibe" || key === "features" || key === "sns") {
                if (!data[key]) {
                    data[key] = [];
                }
                data[key].push(value);
            } else {
                data[key] = value;
            }
        }

        // Save table section checkboxes specifically since they may not submit if unchecked
        const tableCheckboxes = [
            "sec_hero_show", "sec_hero_photo",
            "sec_news_show", "sec_news_photo",
            "sec_profile_show", "sec_profile_photo",
            "sec_business_show", "sec_business_photo",
            "sec_greeting_show", "sec_greeting_photo",
            "sec_service_show", "sec_service_photo",
            "sec_products_show", "sec_products_photo",
            "sec_map_show", "sec_map_photo",
            "sec_access_show", "sec_access_photo",
            "sec_contact_show", "sec_contact_photo"
        ];
        
        tableCheckboxes.forEach(cbName => {
            const cb = document.querySelector(`input[name="${cbName}"]`);
            if (cb) {
                data[cbName] = cb.checked ? "1" : "0";
            }
        });

        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
    }

    // Restore form data from LocalStorage
    function restoreDraft() {
        const raw = localStorage.getItem(STORAGE_KEY);
        if (!raw) return;

        try {
            const data = JSON.parse(raw);
            
            for (const key in data) {
                const value = data[key];
                const elements = document.getElementsByName(key);

                if (elements.length > 0) {
                    if (elements[0].type === "radio") {
                        // Radio button
                        elements.forEach(radio => {
                            if (radio.value === value) {
                                radio.checked = true;
                            }
                        });
                    } else if (elements[0].type === "checkbox") {
                        // Checkbox (single or array)
                        elements.forEach(checkbox => {
                            if (Array.isArray(value)) {
                                if (value.includes(checkbox.value)) {
                                    checkbox.checked = true;
                                }
                            } else if (value === checkbox.value || value === "1") {
                                checkbox.checked = true;
                            }
                        });
                    }
                } else {
                    // Normal text/number input or textarea
                    const el = document.getElementById(key);
                    if (el) {
                        el.value = value;
                    }
                }
            }
        } catch (e) {
            console.error("Error restoring draft", e);
        }
    }

    // Form Submission Handling
    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        // Extra Validation Check
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        // Show Loading Overlay and Disable Buttons
        loadingOverlay.classList.add("show");
        submitBtn.disabled = true;

        // Build Payload
        const formData = new FormData(form);
        const payload = {
            timestamp: new Date().toISOString(),
            company_name: formData.get("company_name"),
            manager_name: formData.get("manager_name"),
            phone: formData.get("phone"),
            email: formData.get("email"),
            site_purpose: formData.get("site_purpose"),
            site_purpose_other: formData.get("purpose_other_text") || "",
            target_age: formData.get("target_age") || "",
            target_gender: formData.get("target_gender") || "",
            target_region: formData.get("target_region") || "",
            design_hope: formData.get("design_hope") || "",
            design_colors: formData.getAll("design_color").join(", "),
            design_vibes: formData.getAll("design_vibe").join(", "),
            design_vibe_other: formData.get("vibe_other_text") || "",
            reference_site_name: formData.get("reference_site_name") || "",
            reference_site_url: formData.get("reference_site_url") || "",
            
            // Section checkboxes status
            sections: {
                hero: { show: !!formData.get("sec_hero_show"), photo: !!formData.get("sec_hero_photo") },
                news: { show: !!formData.get("sec_news_show"), photo: !!formData.get("sec_news_photo") },
                profile: { show: !!formData.get("sec_profile_show"), photo: !!formData.get("sec_profile_photo") },
                business: { show: !!formData.get("sec_business_show"), photo: !!formData.get("sec_business_photo") },
                greeting: { show: !!formData.get("sec_greeting_show"), photo: !!formData.get("sec_greeting_photo") },
                service: { show: !!formData.get("sec_service_show"), photo: !!formData.get("sec_service_photo") },
                products: { show: !!formData.get("sec_products_show"), photo: !!formData.get("sec_products_photo") },
                map: { show: !!formData.get("sec_map_show"), photo: !!formData.get("sec_map_photo") },
                access: { show: !!formData.get("sec_access_show"), photo: !!formData.get("sec_access_photo") },
                contact: { show: !!formData.get("sec_contact_show"), photo: !!formData.get("sec_contact_photo") }
            },
            sec_other: formData.get("sec_other") || "",
            photo_count: formData.get("photo_count") || "0",
            section_texts: {
                hero: formData.get("sec_hero_text") || "",
                news: formData.get("sec_news_text") || "",
                profile: formData.get("sec_profile_text") || "",
                business: formData.get("sec_business_text") || "",
                greeting: formData.get("sec_greeting_text") || "",
                service: formData.get("sec_service_text") || "",
                products: formData.get("sec_products_text") || "",
                map: formData.get("sec_map_text") || "",
                access: formData.get("sec_access_text") || "",
                contact: formData.get("sec_contact_text") || "",
                other: formData.get("sec_other_text") || ""
            },
            features: formData.getAll("features").join(", "),
            plan: formData.get("plan"),
            domain_new: formData.get("domain_new") || "",
            domain_current: formData.get("domain_current") || "",
            domain_name: formData.get("domain_name") || "",
            material_logo: formData.get("material_logo") || "",
            material_photo: formData.get("material_photo") || "",
            material_text: formData.get("material_text") || "",
            final_goal: formData.get("final_goal"),
            final_goal_other: formData.get("final_goal_other_text") || "",
            search_keywords: formData.get("search_keywords") || "",
            device_priority: formData.get("device_priority") || "",
            competitor_name: formData.get("competitor_name") || "",
            competitor_url: formData.get("competitor_url") || "",
            deadline: formData.get("deadline"),
            sns: formData.getAll("sns").join(", ")
        };

        try {
            // If placeholder or empty, simulate successful submission
            if (!GAS_URL || GAS_URL === "ここにGASのWebアプリURLを設定") {
                console.log("Simulating GAS submission. Payload:", payload);
                await new Promise(resolve => setTimeout(resolve, 1500));
            } else {
                const response = await fetch(GAS_URL, {
                    method: "POST",
                    mode: "cors",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    throw new Error("サーバーエラーが発生しました。");
                }
            }

            // Success Handing
            localStorage.removeItem(STORAGE_KEY);
            form.style.display = "none";
            successMessage.style.display = "block";
            window.scrollTo({ top: 0, behavior: "smooth" });

        } catch (error) {
            console.error(error);
            alert("送信中にエラーが発生しました。インターネット接続を確認して再度お試しいただくか、担当者まで直接ご連絡ください。");
        } finally {
            loadingOverlay.classList.remove("show");
            submitBtn.disabled = false;
        }
    });
});

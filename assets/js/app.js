(function () {
    const navToggle = document.querySelector('[data-nav-toggle]');
    const nav = document.querySelector('[data-site-nav]');

    if (navToggle && nav) {
        navToggle.addEventListener('click', function () {
            nav.classList.toggle('open');
        });
    }

    const themeForm = document.querySelector('.theme-form');

    if (themeForm) {
        const themeSelect = themeForm.querySelector('select[name="theme"]');
        const colorInput = themeForm.querySelector('input[name="primary_color"]');

        if (themeSelect) {
            themeSelect.addEventListener('change', function () {
                document.body.dataset.theme = themeSelect.value;
            });
        }

        if (colorInput) {
            colorInput.addEventListener('input', function () {
                document.body.style.setProperty('--accent', colorInput.value);
            });
        }
    }

    const profileTheme = document.querySelector('[data-profile-theme]');
    const profileColor = document.querySelector('[data-profile-color]');

    if (profileTheme) {
        profileTheme.addEventListener('change', function () {
            document.body.dataset.theme = profileTheme.value;
        });
    }

    if (profileColor) {
        profileColor.addEventListener('input', function () {
            document.body.style.setProperty('--accent', profileColor.value);
        });
    }

    const independentToggle = document.querySelector('[data-independent-toggle]');
    const institutionField = document.querySelector('[data-institution-field]');
    const institutionInput = document.querySelector('[data-institution-search]');
    const suggestions = document.querySelector('#institution-suggestions');

    function syncInstitutionField() {
        if (!independentToggle || !institutionField || !institutionInput) {
            return;
        }

        const disabled = independentToggle.checked;
        institutionInput.disabled = disabled;
        institutionInput.required = !disabled;
        institutionField.classList.toggle('muted', disabled);
    }

    if (independentToggle) {
        independentToggle.addEventListener('change', syncInstitutionField);
        syncInstitutionField();
    }

    if (institutionInput && suggestions) {
        let timer = null;

        institutionInput.addEventListener('input', function () {
            const term = institutionInput.value.trim();
            clearTimeout(timer);

            if (term.length < 2) {
                suggestions.innerHTML = '';
                return;
            }

            timer = setTimeout(function () {
                const base = document.body.dataset.baseUrl || '';

                fetch(base + '/instituicoes/buscar?q=' + encodeURIComponent(term), {
                    headers: { 'Accept': 'application/json' }
                })
                    .then(function (response) {
                        return response.ok ? response.json() : { data: [] };
                    })
                    .then(function (payload) {
                        suggestions.innerHTML = '';

                        payload.data.forEach(function (institution) {
                            const option = document.createElement('option');
                            const place = [institution.city, institution.state].filter(Boolean).join(' / ');
                            option.value = institution.name;
                            option.label = place ? institution.name + ' - ' + place : institution.name;
                            suggestions.appendChild(option);
                        });
                    })
                    .catch(function () {
                        suggestions.innerHTML = '';
                    });
            }, 280);
        });
    }

    document.querySelectorAll('[data-confirm]').forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!window.confirm(form.dataset.confirm || 'Confirmar ação?')) {
                event.preventDefault();
            }
        });
    });
    const examTimer = document.querySelector('[data-exam-timer]');
    const examTimerOutput = document.querySelector('[data-exam-timer-output]');

    if (examTimer && examTimerOutput) {
        let remaining = parseInt(examTimer.dataset.examTimer || '0', 10);

        const renderTimer = function () {
            const minutes = Math.floor(Math.max(0, remaining) / 60);
            const seconds = Math.max(0, remaining) % 60;
            examTimerOutput.textContent = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
            examTimer.classList.toggle('danger', remaining <= 60);

            if (remaining > 0) {
                remaining -= 1;
            }
        };

        renderTimer();
        window.setInterval(renderTimer, 1000);
    }

    const chatShell = document.querySelector('[data-chat-refresh]');

    if (chatShell) {
        const interval = parseInt(chatShell.dataset.chatRefresh || '45000', 10);

        window.setInterval(function () {
            const active = document.activeElement;
            const isTyping = active && ['TEXTAREA', 'INPUT', 'SELECT'].includes(active.tagName);

            if (!isTyping) {
                window.location.reload();
            }
        }, Math.max(interval, 15000));
    }
})();

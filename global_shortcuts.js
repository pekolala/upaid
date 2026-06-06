// Global keyboard shortcuts for all forms in Antigravity project
// Press Enter for newline (only in textarea), Ctrl+Enter to submit the form

document.addEventListener('DOMContentLoaded', () => {
  const forms = document.querySelectorAll('form');
  forms.forEach(form => {
    const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
    form.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        if (e.ctrlKey) {
          e.preventDefault();
          if (submitBtn) submitBtn.click();
        } else {
          const target = e.target;
          if (target.tagName !== 'TEXTAREA') {
            e.preventDefault();
          }
        }
      }
    });
  });
});

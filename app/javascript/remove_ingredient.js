document.addEventListener('turbo:load', function() {
  document.querySelectorAll('.remove-ingredient').forEach(function(trashcan) {
    trashcan.addEventListener('click', function() {
      let row = trashcan.closest('.ingredient-row');
      let destroyField = row.querySelector('.destroy-flag');
      if (destroyField) {
        destroyField.value = 'true';
      }
      row.style.display = 'none';
    });
  });
});

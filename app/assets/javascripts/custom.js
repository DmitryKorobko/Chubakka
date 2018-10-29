$(document).ready(function () {
    $('#micropost-field').keyup(function () {
        let micropostSize = $(this).val().length,
            maxLength = 140,
            micropostSymbolsField = $('#micropost-symbols-count-field'),
            micropostSymbolsCountLeft = maxLength - micropostSize,
            micropost = $(this).val();

        if (micropostSymbolsCountLeft >= 0) {
            micropostSymbolsField.text(micropostSymbolsCountLeft + ' characters left');
        } else {
            $(this).val(micropost.slice(0, micropostSymbolsCountLeft));
            micropostSymbolsField.text('0 characters left');
        }
    });
});
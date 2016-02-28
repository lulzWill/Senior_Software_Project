function displayImage(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#previewimage')
                .attr('src', e.target.result)
                .width(250)
                .height(250);
        };

        reader.readAsDataURL(input.files[0]);
    }
}
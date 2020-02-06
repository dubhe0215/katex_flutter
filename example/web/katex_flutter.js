katex_flutter_boundaries = {};
function katex_flutter_render(id) {
    var foundCorrectPlatformView = false;
    // Selecting the correct platform view
    document.querySelectorAll("flt-platform-view").forEach(platformView => {
        var texView = platformView.shadowRoot.children[1];
        if (texView.classList.contains('katex_flutter_code') && texView.id == 'katex_flutter_' + id) {
            // Marking platform view as found
            foundCorrectPlatformView = true;
            // Checking if the LaTeX code was allready rendered by accessing the element's corresponding dataset
            if (texView.dataset['katex_flutter_latex_code'] != undefined) {
                // If allready rendered, resetting innerHTML
                texView.innerHTML = texView.dataset['katex_flutter_latex_code'];
            } else {
                // If not rendered before, saving original code into the element's corresponsing dataset
                texView.dataset['katex_flutter_latex_code'] = texView.innerHTML;
            }
            // Including CSS into the shadow root
            texView.innerHTML += '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">';
            // Overwriting Flutter's style
            texView.style.display = 'inline-block';
            texView.style.overflow = 'auto';
            texView.style.width = 'auto';
            texView.style.height = 'auto';
            var innerContainer = texView.querySelector('.katex_flutter_inner_container');
            innerContainer.style.display = 'inline-block';
            innerContainer.style.width = 'auto';
            innerContainer.style.height = 'auto';
            
            // Marking as rendered
            texView.classList.add('katex_fluter_rendered');
            renderMathInElement(texView, {
                output: 'html',
                delimiters: [{
                    left: "$",
                    right: "$",
                    display: false
                }, {
                    left: "$$",
                    right: "$$",
                    display: true
                }]
            });
            katex_flutter_boundaries[id] = { 'width': getComputedStyle(texView.querySelector('.katex_flutter_inner_container')).width, 'height': getComputedStyle(texView.querySelector('.katex_flutter_inner_container')).height };
        }
    })
    // Checking if the platform view was found. If not, waiting and trying again...
    if (!foundCorrectPlatformView) {
        setTimeout(() => {
            katex_flutter_render(id)
        }, 500);
        return;
    }
}
function katex_flutter_get_boundry(id) {
    if (Object.keys(katex_flutter_boundaries).includes(id)) {
        return katex_flutter_boundaries[id];
    } else {
        return null;
    }
}

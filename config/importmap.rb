# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "marked", to: "https://ga.jspm.io/npm:marked@4.0.12/lib/marked.esm.js"
pin "highlight.js", to: "https://ga.jspm.io/npm:highlight.js@11.5.0/es/index.js"
pin "stimulus-autocomplete", to: "https://ga.jspm.io/npm:stimulus-autocomplete@3.0.1/src/autocomplete.js"

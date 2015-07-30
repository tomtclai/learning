/*jslint browser:true */

var model, controller, catView, catListView;
model = {
    cats: null,
    currentCat: null,
    Cat: function(name, img) {
        this.name = name;
        this.count = 0;
        this.img = img;
    },
    init: function() {
        model.cats = [new model.Cat('Tom', 'cat0.jpg'),
            new model.Cat('Jerry', 'cat1.jpg'),
            new model.Cat('Paul', 'cat2.jpg'),
            new model.Cat('Mary', 'cat3.jpg'),
            new model.Cat('Hillary Clinton', 'cat4.jpg')
        ];
    },
};

controller = {
    init: function() {
        model.init();
        catListView.init();
        catView.init();
    },

    getCurrentCat: function() {
        return model.currentCat;
    },

    getCats: function() {
        return model.cats;
    },

    setCurrentCat: function(cat) {
        model.currentCat = cat;
    },

    incrementCounter: function() {
        model.currentCat.count++;
        catView.render();
    }
};

catView = {
    init: function() {
        this.cat = $('#catBox');
        this.catName = $('#catName');
        this.count = $('#count');
        this.img = $('#cat');
        this.img.click(function() {
            controller.incrementCounter();
        });
        this.render();
    },
    render: function() {
        var currentCat = controller.getCurrentCat();
        if (currentCat) {
            this.count.text(currentCat.count);
            this.catName.text(currentCat.name);
            this.img.attr('src', currentCat.img);
        }

    }
};

catListView = {
    init: function() {
        this.catList = $('#catList');
        this.render();
    },
    render: function() {
        var cat, elem, i;
        var cats = controller.getCats();

        this.catList.innerHTML = '';

        for (i = 0; i < cats.length; i++) {
            cat = cats[i];

            elem = document.createElement('li');
            elem.textContent = cat.name;

            $(elem).click(
                makeCatClickHandler(cat)
            );

            this.catList.append(elem);
        }

        function makeCatClickHandler(catCopy) {
            return function() {
                controller.setCurrentCat(catCopy);
                catView.render();
            };
        }
    }
};

$(document).ready(function() {
    controller.init();
});

!function (a) {
    function b(b, d) {
        this.element = b, this._defaults = {
            "button-style": "btn-default",
            "field-size": "",
            "container-class": "",
            "max-visible-items": 0,
            "filter-type": "",
            "filter-start-from": 1,
            "filter-case-sensitive": !1
        }, this.settings = a.extend({}, this._defaults, d), this._name = c, this._option_values = [], this._currently_selected_option = 0, this._currently_highlighted_option = 0, this._options_container_height = 0, this._options_container_spacing = 0, this._option_height = 0, this._max_height = 0, this._currently_from_top = 0, this.init()
    }
    var c = "bootstrapSelect";
    b.prototype = {
        init: function () {
            var b = this,
                c = new Array("primary", "info", "success", "warning", "danger", "default"),
                d = new Array("lg", "sm"),
                e = new Array("begins", "contains");
            a.inArray(b.settings["button-style"].replace("btn-", ""), c) < 0 && (b.settings["button-style"] = ""), a.inArray(b.settings["field-size"].replace("input-", ""), d) < 0 && (b.settings["field-size"] = ""), a.inArray(b.settings["filter-type"], e) < 0 && (b.settings["filter-type"] = ""), b.settings["container-size"] = "", b.settings["field-size"] > "" && (b.settings["container-size"] = b.settings["field-size"].replace("input-", ""));
            var f = a(b.element).find("option"),
                g = a(b.element).attr("name"),
                h = "";
            a(b.element.attributes).each(function () {
                var a = this.nodeValue;
                void 0 !== a && a !== !1 && "name" !== this.nodeName && "class" !== this.nodeName && (h = h + " " + this.nodeName + '="' + a + '"')
            });
            var i = "";
            b.settings["container-size"] > "" && (i = "bootstrap-" + b.settings["container-size"]), b.generatedSelect = a('<div class="bootstrap-select input-group ' + b.settings["container-class"] + " " + i + '"></div>'), b.generatedSelect.append('<input type="text" autocomplete="off" name="' + g + '_label" class="form-control ' + b.settings["field-size"] + '" ' + h + "/>"), b.generatedSelect.append('<input type="hidden" name="' + g + '" />'), b.generatedSelect.append('<div class="input-group-btn "></div>'), b.generatedSelect.find(".input-group-btn").append('<button tabindex="-1" type="button" class="btn ' + b.settings["button-style"] + ' dropdown-toggle"><span class="caret"></span></button>'), b.generatedSelect.find(".input-group-btn").append('<ul tabindex="-1" class="pull-right dropdown-menu ' + b.settings["button-style"].replace("btn-", "") + '"></ul>');
            var j = "";
            f.each(function () {
                j = a(this).prop("disabled") ? 'class="disabled"' : "", b.generatedSelect.find("ul").append("<li " + j + '><a tabindex="-1" href="' + a(this).val() + '">' + a(this).html() + "</a></li>"), a(this).is(":selected") && b.set_value(a(this).val()), b._option_values.push([a(this).html(), a(this).val(), !0])
            }), a(b.element).replaceWith(b.generatedSelect), b.generatedSelect.on("click", ".dropdown-menu li a", function (c) {
                c.preventDefault(), a(this).closest("li").hasClass("disabled") || (b.close(), b.set_value(a(this).attr("href")))
            }), b.generatedSelect.find('input[type="text"]').bind("focus", function () {
                b.open(), b.settings["filter-type"] > "" && b.show_all_options()
            }), b.generatedSelect.find("button").bind("click", function () {
                b.is_open() ? b.close() : a(this).hasClass("disabled") || b.generatedSelect.find('input[type="text"]').focus()
            }), b.settings["filter-type"] > "" && (b.generatedSelect.find('input[type="text"]').bind("keyup", function (c) {
                var d = [9, 13, 38, 40];
                if (-1 === d.indexOf(c.keyCode)) {
                    var e = a(this).val();
                    e.length >= b.settings["filter-start-from"] ? (b.highlight_value(""), b.generatedSelect.find("a").each(function () {
                        "" === a(this).html() ? (a(this).closest("li").show(), b._option_values[b.generatedSelect.find("li").index(a(this).closest("li"))][2] = !0) : b[b.settings["filter-type"]](a(this).html(), e) ? (a(this).closest("li").show(), b._option_values[b.generatedSelect.find("li").index(a(this).closest("li"))][2] = !0) : (a(this).closest("li").hide(), b._option_values[b.generatedSelect.find("li").index(a(this).closest("li"))][2] = !1)
                    })) : b.show_all_options()
                }
            }), b.generatedSelect.find('input[type="text"]').bind("blur", function () {
                b.set_value(b._option_values[b._currently_selected_option][1])
            })), b.generatedSelect.find("button").bind("blur", function () {
                b.close()
            }), b.generatedSelect.find('input[type="text"]').bind("paste keydown", function (a) {
                if (38 == a.keyCode) if (b.settings["filter-type"] > "") for (var c = !1; !c;) {
                    var d = (b._option_values.length + (b._currently_highlighted_option - 1)) % b._option_values.length;
                    b.highlight_value(b._option_values[d][1]), b._option_values[d][2] && (c = !0)
                } else b._currently_selected_option = (b._option_values.length + (b._currently_selected_option - 1)) % b._option_values.length, b.set_value(b._option_values[b._currently_selected_option][1]);
                else if (40 == a.keyCode) if (b.settings["filter-type"] > "") for (var c = !1; !c;) {
                    var d = (b._currently_highlighted_option + 1) % b._option_values.length;
                    b.highlight_value(b._option_values[d][1]), b._option_values[d][2] && (c = !0)
                } else b._currently_selected_option = (b._currently_selected_option + 1) % b._option_values.length, b.set_value(b._option_values[b._currently_selected_option][1]);
                else if (13 == a.keyCode) b.settings["filter-type"] > "" && b.set_value(b.generatedSelect.find("li.active a").attr("href")), b.close(), b.generatedSelect.find('input[type="text"]').blur();
                else if (9 === a.keyCode) b.close();
                else if (9 !== a.keyCode && "" === b.settings["filter-type"]) {
                    a.preventDefault();
                    for (var e = String.fromCharCode(a.keyCode), f = !1, g = b._currently_selected_option; !f;) g = (g + 1) % b._option_values.length, g === b._currently_selected_option ? f = !0 : b._option_values[g][0][0] === e && (f = !0);
                    b.set_value(b._option_values[g][1])
                }
            }), a("html").bind("click", function (c) {
                var d = a(b.generatedSelect).find('input[type="text"]'),
                    e = a(b.generatedSelect).find(".dropdown-menu li a"),
                    f = a(b.generatedSelect).find("button"),
                    g = a(b.generatedSelect).find("button span");
                a(c.target).is(d) || a(c.target).is(e) || a(c.target).is(f) || a(c.target).is(g) || b.close()
            })
        },
        highlight_value: function (b) {
            var c = a(this.generatedSelect).find('.dropdown-menu li a[href="' + b + '"]').closest("li");
            if (a(this.generatedSelect).find(".dropdown-menu li").removeClass("active"), c.addClass("active"), this._currently_highlighted_option = a(this.generatedSelect).find("li").index(c), this._max_height > 0) {
                for (var d = 0, e = 0; e < this._currently_highlighted_option; e++) this._option_values[e][2] && d++;
                var f = d * this._option_height;
                (f < this._currently_from_top || f >= this._currently_from_top + this._max_height - this._options_container_spacing) && (a(this.generatedSelect).find(".dropdown-menu").scrollTop(f), this._currently_from_top = f)
            }
        },
        show_all_options: function () {
            this.generatedSelect.find("li").show();
            for (var a = 0; a < this._option_values.length; a++) this._option_values[a][2] = !0
        },
        set_value: function (b) {
            var c = a(this.generatedSelect).find('.dropdown-menu li a[href="' + b + '"]').closest("li"),
                d = this.get_value();
            this._currently_selected_option = a(this.generatedSelect).find("li").index(c), this.highlight_value(b), a(this.generatedSelect).find('input[type="text"]').val(c.find("a").html()), a(this.generatedSelect).find('input[type="hidden"]').val(b), d !== b && a(this.generatedSelect).find('input[type="text"]').change()
        },
        get_value: function () {
            return a(this.generatedSelect).find('.dropdown-menu li[class*="active"]').find("a").attr("href")
        },
        close: function () {
            a(this.generatedSelect).find(".input-group-btn").removeClass("open").removeClass("dropup"), a(this.generatedSelect).find(".input-group-btn button").removeClass("active")
        },
        open: function () {
            if (a(this.generatedSelect).find(".input-group-btn").addClass("open"), a(this.generatedSelect).find(".input-group-btn button").addClass("active"), 0 === this._options_container_height && (this._options_container_height = a(this.generatedSelect).find("ul").outerHeight(!0), this._options_container_spacing = this._options_container_height - a(this.generatedSelect).find("ul").height(), this._option_height = a(this.generatedSelect).find("li").outerHeight(!0)), this.settings["max-visible-items"] > 0 && 0 === this._max_height) {
                this._max_height = this.settings["max-visible-items"] * this._option_height + this._options_container_spacing, a(this.generatedSelect).find("ul").css("max-height", this._max_height), this._options_container_height = this._max_height;
                var b = this._currently_selected_option * this._option_height + this._options_container_spacing / 2;
                b >= this._options_container_height && a(this.generatedSelect).find("ul").scrollTop(b - this._options_container_spacing / 2)
            }
            this._options_container_height >= a(document).height() - a(this.generatedSelect).find("ul").offset().top && a(this.generatedSelect).find(".input-group-btn").addClass("dropup")
        },
        is_open: function () {
            return a(this.generatedSelect).find(".input-group-btn").hasClass("open")
        },
        disable: function () {
            a(this.generatedSelect).find('input[type="text"]').attr("disabled", "disabled"), a(this.generatedSelect).find("button").addClass("disabled"), this.close()
        },
        enable: function () {
            a(this.generatedSelect).find('input[type="text"]').removeAttr("disabled"), a(this.generatedSelect).find("button").removeClass("disabled")
        },
        is_disabled: function () {
            return a(this.generatedSelect).find("button").hasClass("disabled")
        },
        begins: function (a, b) {
            return this.settings["filter-case-sensitive"] ? 0 === a.indexOf(b) : 0 === a.toLowerCase().indexOf(b.toLowerCase())
        },
        contains: function (a, b) {
            return this.settings["filter-case-sensitive"] ? a.indexOf(b) >= 0 : a.toLowerCase().indexOf(b.toLowerCase()) >= 0
        },
        add_option: function (b, c, d) {
            "undefined" != typeof d ? d > 0 && (a('<li><a tabindex="-1" href="' + b + '">' + c + "</a></li>").insertAfter(a(this.generatedSelect).find(".dropdown-menu li:nth-child(" + d + ")")), this._option_values.splice(d, 0, [c, b, !0]), d <= this._currently_selected_option && this._currently_selected_option++, d <= this._currently_highlighted_option && (this._currently_highlighted_option++, this._currently_from_top = this._currently_from_to + this._option_height)) : (a(this.generatedSelect).find(".dropdown-menu").append(a('<li><a href="' + b + '">' + c + "</a></li>")), this._option_values.push([c, b, !0]))
        },
        remove_option: function (b) {
            a(this.generatedSelect).find(".dropdown-menu li:nth-child(" + (b + 1) + ")").remove(), this._option_values.splice(b, 1), b === this._currently_selected_option ? this.set_value("") : b < this._currently_selected_option && this._currently_selected_option--, b === this._currently_highlighted_option ? this.highlight_value("") : b < this._currently_highlighted_option && (this._currently_highlighted_option--, this._currently_from_top = this._currently_from_to - this._option_height)
        },
        disable_option: function (b) {
            var c = a(this.generatedSelect).find(".dropdown-menu li:nth-child(" + (b + 1) + ")");
            this.get_value() === c.find("a").attr("href") && this.set_value(""), a(this.generatedSelect).find(".dropdown-menu li:nth-child(" + (b + 1) + ")").addClass("disabled")
        },
        enable_option: function (b) {
            a(this.generatedSelect).find(".dropdown-menu li:nth-child(" + (b + 1) + ")").removeClass("disabled")
        },
        is_option_disabled: function (b) {
            return a(this.generatedSelect).find(".dropdown-menu li:nth-child(" + (b + 1) + ")").hasClass("disabled")
        }
    }, a.fn[c] = function (d) {
        return this.each(function () {
            a.data(this, "plugin_" + c) || a.data(this, "plugin_" + c, new b(this, d))
        })
    }
}(jQuery);
(function ($) {
    $.tools = $.tools || {
        version: '1.2.5'
    };
    var tool;
    var doaction = true;
    tool = $.tools.rangeinput = {
        conf: {
            min: 0,
            max: 100,
            step: 'any',
            steps: 0,
            value: 0,
            precision: undefined,
            vertical: 0,
            keyboard: true,
            progress: false,
            speed: 150,
            css: {
                input: 'range',
                slider: 'rangeslider',
                progress: 'progress',
                handle: 'handle'
            }
        }
    };
    var doc, draggable;
    $.fn.drag = function (conf) {
        document.ondragstart = function () {
            return false;
        };
        conf = $.extend({
            x: true,
            y: true,
            drag: true
        }, conf);
        doc = doc || $(document).bind("mousedown mouseup", function (e) {
            var el = $(e.target);
            if (e.type == "mousedown" && el.data("drag")) {
                var offset = el.position(),
                    x0 = e.pageX - offset.left,
                    y0 = e.pageY - offset.top,
                    start = true;
                doc.bind("mousemove.drag", function (e) {
                    var x = e.pageX - x0,
                        y = e.pageY - y0,
                        props = {};
                    if (conf.x) {
                        props.left = x;
                    }
                    if (conf.y) {
                        props.top = y;
                    }
                    if (start) {
                        el.trigger("dragStart");
                        start = false;
                    }
                    if (conf.drag) {
                        el.css(props);
                    }
                    el.trigger("drag", [y, x]);
                    draggable = el;
                });
                e.preventDefault();
            } else {
                try {
                    if (draggable) {
                        draggable.trigger("dragEnd");
                    }
                } finally {
                    doc.unbind("mousemove.drag");
                    draggable = null;
                }
            }
        });
        return this.data("drag", true);
    };

    function round(value, precision) {
        var n = Math.pow(10, precision);
        return Math.round(value * n) / n;
    }

    function dim(el, key) {
        var v = parseInt(el.css(key), 10);
        if (v) {
            return v;
        }
        var s = el[0].currentStyle;
        return s && s.width && parseInt(s.width, 10);
    }

    function hasEvent(el) {
        var e = el.data("events");
        return e && e.onSlide;
    }

    function RangeInput(input, conf) {
        var self = this,
            css = conf.css,
            root = $("<div><a href='#' class='arrowleft'><span/></a><div class='" + css.progress + "'/><a href='#' class='" + css.handle + "'/><a href='#' class='arrowright'><span/></a></div>").data("rangeinput", self),
            vertical, value, origo, len, pos;
        input.before(root);
        var handle = root.addClass(css.slider).find("a." + css.handle),
            progress = root.find("div." + css.progress),
            aleft = root.find('a.arrowleft'),
            aright = root.find('a.arrowright');
        $.each("min,max,step,value".split(","), function (i, key) {
            var val = input.attr(key);
            if (parseFloat(val)) {
                conf[key] = parseFloat(val, 10);
            }
        });
        var range = conf.max - conf.min,
            step = conf.step == 'any' ? 0 : conf.step,
            precision = conf.precision;
        if (precision === undefined) {
            try {
                precision = step.toString().split(".")[1].length;
            } catch (err) {
                precision = 0;
            }
        }
        if (input.attr("type") == 'range') {
            var tmp = $("<input/>");
            $.each("class,disabled,id,maxlength,name,readonly,required,size,style,tabindex,title,value".split(","), function (i, attr) {
                tmp.attr(attr, input.attr(attr));
            });
            tmp.val(conf.value);
            input.replaceWith(tmp);
            input = tmp;
        }
        input.addClass(css.input);
        var fire = $(self).add(input),
            fireOnSlide = true;

        function slide(evt, x, val, isSetValue) {
            if (val === undefined) {
                val = x / len * range;
            } else if (isSetValue) {
                val -= conf.min;
            }
            if (step) {
                val = Math.round(val / step) * step;
            }
            if (x === undefined || step) {
                x = val * len / range;
            }
            if (isNaN(val)) {
                return self;
            }
            x = Math.max(0, Math.min(x, len));
            val = x / len * range;
            if (isSetValue || !vertical) {
                val += conf.min;
            }
            if (vertical) {
                if (isSetValue) {
                    x = len - x;
                } else {
                    val = conf.max - val;
                }
            }
            val = round(val, precision);
            var isClick = evt.type == "click";
            if (fireOnSlide && value !== undefined && !isClick) {
                evt.type = "onSlide";
                fire.trigger(evt, [val, x]);
                if (evt.isDefaultPrevented()) {
                    return self;
                }
            }
            var speed = isClick ? conf.speed : 0,
                callback = isClick ? function () {
                    evt.type = "change";
                    fire.trigger(evt, [val]);
                } : null;
            if (vertical) {
                handle.animate({
                    top: x
                }, speed, callback);
                if (conf.progress) {
                    progress.animate({
                        height: len - x + handle.width() / 2
                    }, speed);
                }
            } else {
                handle.animate({
                    left: x
                }, speed, callback);
                if (conf.progress) {
                    progress.animate({
                        width: x + handle.width() / 2
                    }, speed);
                }
            }
            value = val;
            pos = x;
            input.val(val);
            return self;
        }
        $.extend(self, {
            getValue: function () {
                return value;
            },
            setValue: function (val, e) {
                init();
                return slide(e || $.Event("api"), undefined, val, true);
            },
            getConf: function () {
                return conf;
            },
            getProgress: function () {
                return progress;
            },
            getHandle: function () {
                return handle;
            },
            getInput: function () {
                return input;
            },
            step: function (am, e) {
                e = e || $.Event();
                var step = conf.step == 'any' ? 1 : conf.step;
                self.setValue(value + step * (am || 1), e);
            },
            stepUp: function (am) {
                return self.step(am || 1);
            },
            stepDown: function (am) {
                return self.step(-am || -1);
            }
        });
        $.each("onSlide,change".split(","), function (i, name) {
            if ($.isFunction(conf[name])) {
                $(self).bind(name, conf[name]);
            }
            self[name] = function (fn) {
                if (fn) {
                    $(self).bind(name, fn);
                }
                return self;
            };
        });
        handle.drag({
            drag: false
        }).bind("dragStart", function () {
            init();
            fireOnSlide = hasEvent($(self)) || hasEvent(input);
        }).bind("drag", function (e, y, x) {
            if (input.is(":disabled")) {
                return false;
            }
            slide(e, vertical ? y : x);
        }).bind("dragEnd", function (e) {
            if (!e.isDefaultPrevented()) {
                e.type = "change";
                fire.trigger(e, [value]);
            }
        }).click(function (e) {
            return e.preventDefault();
        });
        root.click(function (e) {
            if (doaction) {
                if (input.is(":disabled") || e.target == handle[0]) {
                    return e.preventDefault();
                }
                init();
                var fix = handle.width() / 2;
                slide(e, vertical ? len - origo - fix + e.pageY : e.pageX - origo - fix);
            } else {
                doaction = true;
            }
        });
        aleft.click(function () {
            doaction = false;
            if (vertical) {
                var val = self.getValue() + step;
            } else {
                var val = self.getValue() - step;
            }
            if (val >= conf.min) {
                self.setValue(val);
            }
            return false;
        });
        aright.click(function () {
            doaction = false;
            if (vertical) {
                var val = self.getValue() - step;
            } else {
                var val = self.getValue() + step;
            }
            if (val <= conf.max) {
                self.setValue(val);
            }
            return false;
        });
        if (conf.keyboard) {
            input.keydown(function (e) {
                if (input.attr("readonly")) {
                    return;
                }
                var key = e.keyCode,
                    up = $([75, 76, 38, 33, 39]).index(key) != -1,
                    down = $([74, 72, 40, 34, 37]).index(key) != -1;
                if ((up || down) && !(e.shiftKey || e.altKey || e.ctrlKey)) {
                    if (up) {
                        self.step(key == 33 ? 10 : 1, e);
                    } else if (down) {
                        self.step(key == 34 ? -10 : -1, e);
                    }
                    return e.preventDefault();
                }
            });
        }
        input.blur(function (e) {
            var val = $(this).val();
            if (val !== value) {
                self.setValue(val, e);
            }
        });
        $.extend(input[0], {
            stepUp: self.stepUp,
            stepDown: self.stepDown
        });

        function init() {
            vertical = conf.vertical || dim(root, "height") > dim(root, "width");
            if (vertical) {
                var handlesize = Math.round(root.height() / ((conf.max + conf.step) / conf.step));
                handle.css('height', handlesize + 'px');
                len = dim(root, "height") - handlesize;
                origo = root.offset().top + len;
            } else {
                var handlesize = Math.round(root.width() / ((conf.max + conf.step) / conf.step));
                handle.css('width', handlesize + 'px');
                len = root.width() - handlesize;
                origo = root.offset().left;
            }
        }

        function begin() {
            init();
            self.setValue(conf.value !== undefined ? conf.value : conf.min);
        }
        begin();
        if (!len) {
            $(window).load(begin);
        }
    }
    $.expr[':'].range = function (el) {
        var type = el.getAttribute("type");
        return type && type == 'range' || !! $(el).filter("input").data("rangeinput");
    };
    $.fn.rangeinput = function (conf) {
        if (this.data("rangeinput")) {
            return this;
        }
        conf = $.extend(true, {}, tool.conf, conf);
        var els;
        this.each(function () {
            var el = new RangeInput($(this), $.extend(true, {}, conf));
            var input = el.getInput().data("rangeinput", el);
            els = els ? els.add(input) : input;
        });
        return els ? els : this;
    };
})(jQuery);;
(function ($) {
    function format(str) {
        for (var i = 1; i < arguments.length; i++) {
            str = str.replace('%' + (i - 1), arguments[i]);
        }
        return str;
    }

    function CloudZoom(jWin, opts) {
        var sImg = $('img', jWin);
        var img1;
        var img2;
        var zoomDiv = null;
        var $mouseTrap = null;
        var lens = null;
        var $tint = null;
        var softFocus = null;
        var $ie6Fix = null;
        var zoomImage;
        var controlTimer = 0;
        var cw, ch;
        var destU = 0;
        var destV = 0;
        var currV = 0;
        var currU = 0;
        var filesLoaded = 0;
        var mx, my;
        var ctx = this,
            zw;
        var mobile = $("body").hasClass('mobile');
        if (mobile == false) {
            setTimeout(function () {
                if ($mouseTrap === null) {
                    var w = jWin.width();
                    jWin.parent().append(format('<div style="width:%0px;position:absolute;top:75%;left:%1px;text-align:center" class="cloud-zoom-loading" >Loading...</div>', w / 3, (w / 2) - (w / 6))).find(':last').css('opacity', 0.5);
                }
            }, 200);
        }
        var ie6FixRemove = function () {
            if ($ie6Fix !== null) {
                $ie6Fix.remove();
                $ie6Fix = null;
            }
        };
        this.removeBits = function () {
            if (lens) {
                lens.remove();
                lens = null;
            }
            if ($tint) {
                $tint.remove();
                $tint = null;
            }
            if (softFocus) {
                softFocus.remove();
                softFocus = null;
            }
            ie6FixRemove();
            $('.cloud-zoom-loading', jWin.parent()).remove();
        };
        this.destroy = function () {
            jWin.data('zoom', null);
            if ($mouseTrap) {
                $mouseTrap.unbind();
                $mouseTrap.remove();
                $mouseTrap = null;
            }
            if (zoomDiv) {
                zoomDiv.remove();
                zoomDiv = null;
            }
            this.removeBits();
        };
        this.fadedOut = function () {
            if (zoomDiv) {
                zoomDiv.remove();
                zoomDiv = null;
            }
            this.removeBits();
        };
        this.controlLoop = function () {
            if (lens) {
                var x = (mx - sImg.offset().left - (cw * 0.5)) >> 0;
                var y = (my - sImg.offset().top - (ch * 0.5)) >> 0;
                if (x < 0) {
                    x = 0;
                } else if (x > (sImg.outerWidth() - cw)) {
                    x = (sImg.outerWidth() - cw);
                }
                if (y < 0) {
                    y = 0;
                } else if (y > (sImg.outerHeight() - ch)) {
                    y = (sImg.outerHeight() - ch);
                }
                lens.css({
                    left: x,
                    top: y
                });
                lens.css('background-position', (-x) + 'px ' + (-y) + 'px');
                destU = (((x) / sImg.outerWidth()) * zoomImage.width) >> 0;
                destV = (((y) / sImg.outerHeight()) * zoomImage.height) >> 0;
                currU += (destU - currU) / opts.smoothMove;
                currV += (destV - currV) / opts.smoothMove;
                zoomDiv.css('background-position', (-(currU >> 0) + 'px ') + (-(currV >> 0) + 'px'));
            }
            controlTimer = setTimeout(function () {
                ctx.controlLoop();
            }, 30);
        };
        this.init2 = function (img, id) {
            filesLoaded++;
            if (id === 1) {
                zoomImage = img;
            }
            if (filesLoaded === 2) {
                this.init();
            }
        };
        this.init = function () {
            $('.cloud-zoom-loading', jWin.parent()).remove();
            $('#mousetrap').remove();
            $mouseTrap = jWin.parent().append(format("<div id='mousetrap' class='mousetrap' style='z-index:400;position:absolute;width:%0px;height:%1px;left:%2px;top:%3px;\'></div>", sImg.outerWidth(), sImg.outerHeight(), 0, 0)).find(':last');
            $mouseTrap.html('<div id=\"js_FullZoom\" class=\"fullZoom\">&nbsp;</div>');
            $mouseTrap.trigger('moustrap_active');
            $mouseTrap.bind('mousemove', this, function (event) {
                mx = event.pageX;
                my = event.pageY;
            });
            if (mobile == false) {
                $mouseTrap.bind('mouseleave', this, function (event) {
                    clearTimeout(controlTimer);
                    if (lens) {
                        lens.fadeOut(299);
                    }
                    if ($tint) {
                        $tint.fadeOut(299);
                    }
                    if (softFocus) {
                        softFocus.fadeOut(299);
                    }
                    $('.cloud-zoom-shadow').fadeOut(10);
                    $('.cloud-zoom-shadow').remove();
                    zoomDiv.fadeOut(300, function () {
                        ctx.fadedOut();
                    });
                    return false;
                });
            }
            $mouseTrap.bind('mouseenter', this, function (event) {
                mx = event.pageX;
                my = event.pageY;
                zw = event.data;
                if (zoomDiv) {
                    zoomDiv.stop(true, false);
                    zoomDiv.remove();
                }
                var xPos = opts.adjustX,
                    yPos = opts.adjustY;
                var siw = sImg.outerWidth();
                var sih = sImg.outerHeight();
                var w = opts.zoomWidth;
                var h = opts.zoomHeight;
                if (opts.zoomWidth == 'auto') {
                    w = siw;
                }
                if (opts.zoomHeight == 'auto') {
                    h = sih;
                }
                var appendTo = jWin.parent();
                switch (opts.position) {
                    case 'top':
                        yPos -= h;
                        break;
                    case 'right':
                        xPos += siw;
                        break;
                    case 'bottom':
                        yPos += sih;
                        break;
                    case 'left':
                        xPos -= w;
                        break;
                    case 'inside':
                        w = siw;
                        h = sih;
                        break;
                    default:
                        appendTo = $('#' + opts.position);
                        if (!appendTo.length) {
                            appendTo = jWin;
                            xPos += siw;
                            yPos += sih;
                        } else {
                            w = appendTo.innerWidth();
                            h = appendTo.innerHeight();
                        }
                }
                if (mobile == false) {
                    zoomDiv = appendTo.append(format('<div id="cloud-zoom-shadow2" class="cloud-zoom-shadow" style="position:absolute;left:%0px;top:%1px;width:%2px;height:%3px;z-index:980;"><div class="sh_r"><div class="lb_shadow_r sh_tr" ></div><div class="lb_shadow_r sh_cr"></div></div><div class="sh_b"><div class="lb_shadow_b sh_lb"></div><div class="lb_shadow_b sh_cb"></div><div class="lb_shadow_b sh_rb"></div></div></div>', xPos, yPos, w + 35, h + 35)).find(':last');
                    zoomDiv = appendTo.append(format('<div id="cloud-zoom-big" class="cloud-zoom-big" style="display:none;position:absolute;left:%0px;top:%1px;width:%2px;height:%3px;background-image:url(\'%4\');z-index:990;"></div>', xPos, yPos, w, h, zoomImage.src)).find(':last');
                    if (sImg.attr('title') && opts.showTitle) {
                        zoomDiv.append(format('<div class="cloud-zoom-title">%0</div>', sImg.attr('title'))).find(':last').css('opacity', opts.titleOpacity);
                    }
                }
                if ($.browser.msie && $.browser.version < 7) {
                    $ie6Fix = $('<iframe frameborder="0" src="#"></iframe>').css({
                        position: "absolute",
                        left: xPos,
                        top: yPos,
                        zIndex: 99,
                        width: w,
                        height: h
                    }).insertBefore(zoomDiv);
                }
                if (mobile == false) {
                    zoomDiv.fadeIn(500);
                }
                if (lens) {
                    lens.remove();
                    lens = null;
                }
                if (mobile == false) {
                    cw = (sImg.outerWidth() / zoomImage.width) * zoomDiv.width();
                    ch = (sImg.outerHeight() / zoomImage.height) * zoomDiv.height();
                }
                lens = jWin.append(format("<div class='cloud-zoom-lens' style='display:none;z-index:98;position:absolute;width:%0px;height:%1px;'></div>", cw, ch)).find(':last');
                lens.html('<div class="trapMod"></div>');
                if (mobile == true) {
                    return true;
                }
                $mouseTrap.css('cursor', lens.css('cursor'));
                var noTrans = false;
                if (opts.tint) {
                    lens.css('background', 'url("' + sImg.attr('src') + '")');
                    $tint = jWin.append(format('<div style="display:none;position:absolute; left:0px; top:0px; width:%0px; height:%1px; background-color:%2;" />', sImg.outerWidth(), sImg.outerHeight(), opts.tint)).find(':last');
                    $tint.css('opacity', opts.tintOpacity);
                    noTrans = true;
                    $tint.fadeIn(500);
                }
                if (opts.softFocus) {
                    lens.css('background', 'url("' + sImg.attr('src') + '")');
                    softFocus = jWin.append(format('<div style="position:absolute;display:none;top:2px; left:2px; width:%0px; height:%1px;" />', sImg.outerWidth() - 2, sImg.outerHeight() - 2, opts.tint)).find(':last');
                    softFocus.css('background', 'url("' + sImg.attr('src') + '")');
                    softFocus.css('opacity', 0.5);
                    noTrans = true;
                    softFocus.fadeIn(500);
                }
                if (!noTrans) {
                    lens.css('opacity', opts.lensOpacity);
                }
                if (opts.position !== 'inside') {
                    lens.fadeIn(500);
                }
                zw.controlLoop();
                return;
            });
        };
        img1 = new Image();
        $(img1).load(function () {
            ctx.init2(this, 0);
        });
        img1.src = sImg.attr('src');
        img2 = new Image();
        $(img2).load(function () {
            ctx.init2(this, 1);
        });
        img2.src = jWin.attr('href');
    }
    $.fn.CloudZoom = function (options) {
        try {
            document.execCommand("BackgroundImageCache", false, true);
        } catch (e) {}
        this.each(function () {
            var relOpts, opts;
            eval('var    a = {' + $(this).attr('rel') + '}');
            relOpts = a;
            if ($(this).is('.cloud-zoom')) {
                $(this).css({
                    'position': 'relative',
                    'display': 'block'
                });
                $('img', $(this)).css({
                    'display': 'block'
                });
                if ($(this).parent().attr('id') != 'wrap') {
                    $(this).wrap('<div id="wrap" style="top:0px;position:relative;"></div>');
                }
                opts = $.extend({}, $.fn.CloudZoom.defaults, options);
                opts = $.extend({}, opts, relOpts);
                $(this).data('zoom', new CloudZoom($(this), opts));
            } else if ($(this).is('.cloud-zoom-gallery')) {
                opts = $.extend({}, relOpts, options);
                $(this).data('relOpts', opts);
                $(this).bind('click', $(this), function (event) {
                    var data = event.data.data('relOpts');
                    $('#' + data.useZoom).data('zoom').destroy();
                    $('#' + data.useZoom).attr('href', event.data.attr('href'));
                    $('#' + data.useZoom + ' img').attr('src', event.data.data('relOpts').smallImage);
                    $('#' + event.data.data('relOpts').useZoom).CloudZoom();
                    return false;
                });
            }
        });
        return this;
    };
    $.fn.CloudZoom.defaults = {
        zoomWidth: 'auto',
        zoomHeight: 'auto',
        position: 'right',
        tint: false,
        tintOpacity: 0.5,
        lensOpacity: 0.5,
        softFocus: false,
        smoothMove: 3,
        showTitle: true,
        titleOpacity: 0.5,
        adjustX: 0,
        adjustY: 0
    };
})(jQuery);;;
(function ($) {
    var o = $.scrollTo = function (a, b, c) {
        o.window().scrollTo(a, b, c)
    };
    o.defaults = {
        axis: 'y',
        duration: 1
    };
    o.window = function () {
        return $($.browser.safari ? 'body' : 'html')
    };
    $.fn.scrollTo = function (l, m, n) {
        if (typeof m == 'object') {
            n = m;
            m = 0
        }
        n = $.extend({}, o.defaults, n);
        m = m || n.speed || n.duration;
        n.queue = n.queue && n.axis.length > 1;
        if (n.queue) m /= 2;
        n.offset = j(n.offset);
        n.over = j(n.over);
        return this.each(function () {
            var a = this,
                b = $(a),
                t = l,
                c, d = {}, w = b.is('html,body');
            switch (typeof t) {
                case 'number':
                case 'string':
                    if (/^([+-]=)?\d+(px)?$/.test(t)) {
                        t = j(t);
                        break
                    }
                    t = $(t, this);
                case 'object':
                    if (t.is || t.style) c = (t = $(t)).offset()
            }
            $.each(n.axis.split(''), function (i, f) {
                var P = f == 'x' ? 'Left' : 'Top',
                    p = P.toLowerCase(),
                    k = 'scroll' + P,
                    e = a[k],
                    D = f == 'x' ? 'Width' : 'Height';
                if (c) {
                    d[k] = c[p] + (w ? 0 : e - b.offset()[p]);
                    if (n.margin) {
                        d[k] -= parseInt(t.css('margin' + P)) || 0;
                        d[k] -= parseInt(t.css('border' + P + 'Width')) || 0
                    }
                    d[k] += n.offset[p] || 0;
                    if (n.over[p]) d[k] += t[D.toLowerCase()]() * n.over[p]
                } else d[k] = t[p]; if (/^\d+$/.test(d[k])) d[k] = d[k] <= 0 ? 0 : Math.min(d[k], h(D));
                if (!i && n.queue) {
                    if (e != d[k]) g(n.onAfterFirst);
                    delete d[k]
                }
            });
            g(n.onAfter);

            function g(a) {
                b.animate(d, m, n.easing, a && function () {
                    a.call(this, l)
                })
            };

            function h(D) {
                var b = w ? $.browser.opera ? document.body : document.documentElement : a;
                return b['scroll' + D] - b['client' + D]
            }
        })
    };

    function j(a) {
        return typeof a == 'object' ? a : {
            top: a,
            left: a
        }
    }
})(jQuery);;
(function ($) {
    function Countdown() {
        this.regional = [];
        this.regional[''] = {
            labels: ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Seconds'],
            labels1: ['Year', 'Month', 'Week', 'Day', 'Hour', 'Minute', 'Second'],
            compactLabels: ['y', 'm', 'w', 'd'],
            timeSeparator: ':',
            isRTL: false
        };
        this._defaults = {
            until: null,
            since: null,
            timezone: null,
            serverSync: null,
            format: 'dHMS',
            layout: '',
            compact: false,
            description: '',
            expiryUrl: '',
            expiryText: '',
            alwaysExpire: false,
            onExpiry: null,
            onTick: null
        };
        $.extend(this._defaults, this.regional[''])
    }
    var w = 'countdown';
    var Y = 0;
    var O = 1;
    var W = 2;
    var D = 3;
    var H = 4;
    var M = 5;
    var S = 6;
    $.extend(Countdown.prototype, {
        markerClassName: 'hasCountdown',
        _timer: setInterval(function () {
            $.countdown._updateTargets()
        }, 980),
        _timerTargets: [],
        setDefaults: function (a) {
            this._resetExtraLabels(this._defaults, a);
            extendRemove(this._defaults, a || {})
        },
        UTCDate: function (a, b, c, e, f, g, h, i) {
            if (typeof b == 'object' && b.constructor == Date) {
                i = b.getMilliseconds();
                h = b.getSeconds();
                g = b.getMinutes();
                f = b.getHours();
                e = b.getDate();
                c = b.getMonth();
                b = b.getFullYear()
            }
            var d = new Date();
            d.setUTCFullYear(b);
            d.setUTCDate(1);
            d.setUTCMonth(c || 0);
            d.setUTCDate(e || 1);
            d.setUTCHours(f || 0);
            d.setUTCMinutes((g || 0) - (Math.abs(a) < 30 ? a * 60 : a));
            d.setUTCSeconds(h || 0);
            d.setUTCMilliseconds(i || 0);
            return d
        },
        _settingsCountdown: function (a, b) {
            if (!b) {
                return $.countdown._defaults
            }
            var c = $.data(a, w);
            return (b == 'all' ? c.options : c.options[b])
        },
        _attachCountdown: function (a, b) {
            var c = $(a);
            if (c.hasClass(this.markerClassName)) {
                return
            }
            c.addClass(this.markerClassName);
            var d = {
                options: $.extend({}, b),
                _periods: [0, 0, 0, 0, 0, 0, 0]
            };
            $.data(a, w, d);
            this._changeCountdown(a)
        },
        _addTarget: function (a) {
            if (!this._hasTarget(a)) {
                this._timerTargets.push(a)
            }
        },
        _hasTarget: function (a) {
            return ($.inArray(a, this._timerTargets) > -1)
        },
        _removeTarget: function (b) {
            this._timerTargets = $.map(this._timerTargets, function (a) {
                return (a == b ? null : a)
            })
        },
        _updateTargets: function () {
            for (var i = 0; i < this._timerTargets.length; i++) {
                this._updateCountdown(this._timerTargets[i])
            }
        },
        _updateCountdown: function (a, b) {
            var c = $(a);
            b = b || $.data(a, w);
            if (!b) {
                return
            }
            c.html(this._generateHTML(b));
            c[(this._get(b, 'isRTL') ? 'add' : 'remove') + 'Class']('countdown_rtl');
            var d = this._get(b, 'onTick');
            if (d) {
                d.apply(a, [b._hold != 'lap' ? b._periods : this._calculatePeriods(b, b._show, new Date())])
            }
            var e = b._hold != 'pause' && (b._since ? b._now.getTime() <= b._since.getTime() : b._now.getTime() >= b._until.getTime());
            if (e && !b._expiring) {
                b._expiring = true;
                if (this._hasTarget(a) || this._get(b, 'alwaysExpire')) {
                    this._removeTarget(a);
                    var f = this._get(b, 'onExpiry');
                    if (f) {
                        f.apply(a, [])
                    }
                    var g = this._get(b, 'expiryText');
                    if (g) {
                        var h = this._get(b, 'layout');
                        b.options.layout = g;
                        this._updateCountdown(a, b);
                        b.options.layout = h
                    }
                    var i = this._get(b, 'expiryUrl');
                    if (i) {
                        window.location = i
                    }
                }
                b._expiring = false
            } else if (b._hold == 'pause') {
                this._removeTarget(a)
            }
            $.data(a, w, b)
        },
        _changeCountdown: function (a, b, c) {
            b = b || {};
            if (typeof b == 'string') {
                var d = b;
                b = {};
                b[d] = c
            }
            var e = $.data(a, w);
            if (e) {
                this._resetExtraLabels(e.options, b);
                extendRemove(e.options, b);
                this._adjustSettings(a, e);
                $.data(a, w, e);
                var f = new Date();
                if ((e._since && e._since < f) || (e._until && e._until > f)) {
                    this._addTarget(a)
                }
                this._updateCountdown(a, e)
            }
        },
        _resetExtraLabels: function (a, b) {
            var c = false;
            for (var n in b) {
                if (n.match(/[Ll]abels/)) {
                    c = true;
                    break
                }
            }
            if (c) {
                for (var n in a) {
                    if (n.match(/[Ll]abels[0-9]/)) {
                        a[n] = null
                    }
                }
            }
        },
        _adjustSettings: function (a, b) {
            var c = this._get(b, 'serverSync');
            c = (c ? c.apply(a, []) : null);
            var d = new Date();
            var e = this._get(b, 'timezone');
            e = (e == null ? -d.getTimezoneOffset() : e);
            b._since = this._get(b, 'since');
            if (b._since) {
                b._since = this.UTCDate(e, this._determineTime(b._since, null));
                if (b._since && c) {
                    b._since.setMilliseconds(b._since.getMilliseconds() + d.getTime() - c.getTime())
                }
            }
            b._until = this.UTCDate(e, this._determineTime(this._get(b, 'until'), d));
            if (c) {
                b._until.setMilliseconds(b._until.getMilliseconds() + d.getTime() - c.getTime())
            }
            b._show = this._determineShow(b)
        },
        _destroyCountdown: function (a) {
            var b = $(a);
            if (!b.hasClass(this.markerClassName)) {
                return
            }
            this._removeTarget(a);
            b.removeClass(this.markerClassName).empty();
            $.removeData(a, w)
        },
        _pauseCountdown: function (a) {
            this._hold(a, 'pause')
        },
        _lapCountdown: function (a) {
            this._hold(a, 'lap')
        },
        _resumeCountdown: function (a) {
            this._hold(a, null)
        },
        _hold: function (a, b) {
            var c = $.data(a, w);
            if (c) {
                if (c._hold == 'pause' && !b) {
                    c._periods = c._savePeriods;
                    var d = (c._since ? '-' : '+');
                    c[c._since ? '_since' : '_until'] = this._determineTime(d + c._periods[0] + 'y' + d + c._periods[1] + 'o' + d + c._periods[2] + 'w' + d + c._periods[3] + 'd' + d + c._periods[4] + 'h' + d + c._periods[5] + 'm' + d + c._periods[6] + 's');
                    this._addTarget(a)
                }
                c._hold = b;
                c._savePeriods = (b == 'pause' ? c._periods : null);
                $.data(a, w, c);
                this._updateCountdown(a, c)
            }
        },
        _getTimesCountdown: function (a) {
            var b = $.data(a, w);
            return (!b ? null : (!b._hold ? b._periods : this._calculatePeriods(b, b._show, new Date())))
        },
        _get: function (a, b) {
            return (a.options[b] != null ? a.options[b] : $.countdown._defaults[b])
        },
        _determineTime: function (k, l) {
            var m = function (a) {
                var b = new Date();
                b.setTime(b.getTime() + a * 1000);
                return b
            };
            var n = function (a) {
                a = a.toLowerCase();
                var b = new Date();
                var c = b.getFullYear();
                var d = b.getMonth();
                var e = b.getDate();
                var f = b.getHours();
                var g = b.getMinutes();
                var h = b.getSeconds();
                var i = /([+-]?[0-9]+)\s*(s|m|h|d|w|o|y)?/g;
                var j = i.exec(a);
                while (j) {
                    switch (j[2] || 's') {
                        case 's':
                            h += parseInt(j[1], 10);
                            break;
                        case 'm':
                            g += parseInt(j[1], 10);
                            break;
                        case 'h':
                            f += parseInt(j[1], 10);
                            break;
                        case 'd':
                            e += parseInt(j[1], 10);
                            break;
                        case 'w':
                            e += parseInt(j[1], 10) * 7;
                            break;
                        case 'o':
                            d += parseInt(j[1], 10);
                            e = Math.min(e, $.countdown._getDaysInMonth(c, d));
                            break;
                        case 'y':
                            c += parseInt(j[1], 10);
                            e = Math.min(e, $.countdown._getDaysInMonth(c, d));
                            break
                    }
                    j = i.exec(a)
                }
                return new Date(c, d, e, f, g, h, 0)
            };
            var o = (k == null ? l : (typeof k == 'string' ? n(k) : (typeof k == 'number' ? m(k) : k)));
            if (o) o.setMilliseconds(0);
            return o
        },
        _getDaysInMonth: function (a, b) {
            return 32 - new Date(a, b, 32).getDate()
        },
        _generateHTML: function (c) {
            c._periods = periods = (c._hold ? c._periods : this._calculatePeriods(c, c._show, new Date()));
            var d = false;
            var e = 0;
            for (var f = 0; f < c._show.length; f++) {
                d |= (c._show[f] == '?' && periods[f] > 0);
                c._show[f] = (c._show[f] == '?' && !d ? null : c._show[f]);
                e += (c._show[f] ? 1 : 0)
            }
            var g = this._get(c, 'compact');
            var h = this._get(c, 'layout');
            var i = (g ? this._get(c, 'compactLabels') : this._get(c, 'labels'));
            var j = this._get(c, 'timeSeparator');
            var k = this._get(c, 'description') || '';
            var l = function (a) {
                var b = $.countdown._get(c, 'compactLabels' + periods[a]);
                return (c._show[a] ? periods[a] + (b ? b[a] : i[a]) + ' ' : '')
            };
            var m = function (a) {
                var b = $.countdown._get(c, 'labels' + periods[a]);
                return (c._show[a] ? '<span class="countdown_section"><span class="countdown_amount">' + periods[a] + '</span><br/>' + (b ? b[a] : i[a]) + '</span>' : '')
            };
            return (h ? this._buildLayout(c, h, g) : ((g ? '<span class="countdown_row countdown_amount' + (c._hold ? ' countdown_holding' : '') + '">' + l(Y) + l(O) + l(W) + l(D) + (c._show[H] ? this._minDigits(periods[H], 2) : '') + (c._show[M] ? (c._show[H] ? j : '') + this._minDigits(periods[M], 2) : '') + (c._show[S] ? (c._show[H] || c._show[M] ? j : '') + this._minDigits(periods[S], 2) : '') : '<span class="countdown_row countdown_show' + e + (c._hold ? ' countdown_holding' : '') + '">' + m(Y) + m(O) + m(W) + m(D) + m(H) + m(M) + m(S)) + '</span>' + (k ? '<span class="countdown_row countdown_descr">' + k + '</span>' : '')))
        },
        _buildLayout: function (c, d, e) {
            var f = this._get(c, (e ? 'compactLabels' : 'labels'));
            var g = function (a) {
                return ($.countdown._get(c, (e ? 'compactLabels' : 'labels') + c._periods[a]) || f)[a]
            };
            var h = function (a, b) {
                return Math.floor(a / b) % 10
            };
            var j = {
                desc: this._get(c, 'description'),
                sep: this._get(c, 'timeSeparator'),
                yl: g(Y),
                yn: c._periods[Y],
                ynn: this._minDigits(c._periods[Y], 2),
                ynnn: this._minDigits(c._periods[Y], 3),
                y1: h(c._periods[Y], 1),
                y10: h(c._periods[Y], 10),
                y100: h(c._periods[Y], 100),
                y1000: h(c._periods[Y], 1000),
                ol: g(O),
                on: c._periods[O],
                onn: this._minDigits(c._periods[O], 2),
                onnn: this._minDigits(c._periods[O], 3),
                o1: h(c._periods[O], 1),
                o10: h(c._periods[O], 10),
                o100: h(c._periods[O], 100),
                o1000: h(c._periods[O], 1000),
                wl: g(W),
                wn: c._periods[W],
                wnn: this._minDigits(c._periods[W], 2),
                wnnn: this._minDigits(c._periods[W], 3),
                w1: h(c._periods[W], 1),
                w10: h(c._periods[W], 10),
                w100: h(c._periods[W], 100),
                w1000: h(c._periods[W], 1000),
                dl: g(D),
                dn: c._periods[D],
                dnn: this._minDigits(c._periods[D], 2),
                dnnn: this._minDigits(c._periods[D], 3),
                d1: h(c._periods[D], 1),
                d10: h(c._periods[D], 10),
                d100: h(c._periods[D], 100),
                d1000: h(c._periods[D], 1000),
                hl: g(H),
                hn: c._periods[H],
                hnn: this._minDigits(c._periods[H], 2),
                hnnn: this._minDigits(c._periods[H], 3),
                h1: h(c._periods[H], 1),
                h10: h(c._periods[H], 10),
                h100: h(c._periods[H], 100),
                h1000: h(c._periods[H], 1000),
                ml: g(M),
                mn: c._periods[M],
                mnn: this._minDigits(c._periods[M], 2),
                mnnn: this._minDigits(c._periods[M], 3),
                m1: h(c._periods[M], 1),
                m10: h(c._periods[M], 10),
                m100: h(c._periods[M], 100),
                m1000: h(c._periods[M], 1000),
                sl: g(S),
                sn: c._periods[S],
                snn: this._minDigits(c._periods[S], 2),
                snnn: this._minDigits(c._periods[S], 3),
                s1: h(c._periods[S], 1),
                s10: h(c._periods[S], 10),
                s100: h(c._periods[S], 100),
                s1000: h(c._periods[S], 1000)
            };
            var k = d;
            for (var i = 0; i < 7; i++) {
                var l = 'yowdhms'.charAt(i);
                var m = new RegExp('\\{' + l + '<\\}(.*)\\{' + l + '>\\}', 'g');
                k = k.replace(m, (c._show[i] ? '$1' : ''))
            }
            $.each(j, function (n, v) {
                var a = new RegExp('\\{' + n + '\\}', 'g');
                k = k.replace(a, v)
            });
            return k
        },
        _minDigits: function (a, b) {
            a = '' + a;
            if (a.length >= b) {
                return a
            }
            a = '0000000000' + a;
            return a.substr(a.length - b)
        },
        _determineShow: function (a) {
            var b = this._get(a, 'format');
            var c = [];
            c[Y] = (b.match('y') ? '?' : (b.match('Y') ? '!' : null));
            c[O] = (b.match('o') ? '?' : (b.match('O') ? '!' : null));
            c[W] = (b.match('w') ? '?' : (b.match('W') ? '!' : null));
            c[D] = (b.match('d') ? '?' : (b.match('D') ? '!' : null));
            c[H] = (b.match('h') ? '?' : (b.match('H') ? '!' : null));
            c[M] = (b.match('m') ? '?' : (b.match('M') ? '!' : null));
            c[S] = (b.match('s') ? '?' : (b.match('S') ? '!' : null));
            return c
        },
        _calculatePeriods: function (f, g, h) {
            f._now = h;
            f._now.setMilliseconds(0);
            var i = new Date(f._now.getTime());
            if (f._since) {
                if (h.getTime() < f._since.getTime()) {
                    f._now = h = i
                } else {
                    h = f._since
                }
            } else {
                i.setTime(f._until.getTime());
                if (h.getTime() > f._until.getTime()) {
                    f._now = h = i
                }
            }
            var j = [0, 0, 0, 0, 0, 0, 0];
            if (g[Y] || g[O]) {
                var k = $.countdown._getDaysInMonth(h.getFullYear(), h.getMonth());
                var l = $.countdown._getDaysInMonth(i.getFullYear(), i.getMonth());
                var m = (i.getDate() == h.getDate() || (i.getDate() >= Math.min(k, l) && h.getDate() >= Math.min(k, l)));
                var n = function (a) {
                    return (a.getHours() * 60 + a.getMinutes()) * 60 + a.getSeconds()
                };
                var o = Math.max(0, (i.getFullYear() - h.getFullYear()) * 12 + i.getMonth() - h.getMonth() + ((i.getDate() < h.getDate() && !m) || (m && n(i) < n(h)) ? -1 : 0));
                j[Y] = (g[Y] ? Math.floor(o / 12) : 0);
                j[O] = (g[O] ? o - j[Y] * 12 : 0);
                var p = function (a, b, c) {
                    var d = (a.getDate() == c);
                    var e = $.countdown._getDaysInMonth(a.getFullYear() + b * j[Y], a.getMonth() + b * j[O]);
                    if (a.getDate() > e) {
                        a.setDate(e)
                    }
                    a.setFullYear(a.getFullYear() + b * j[Y]);
                    a.setMonth(a.getMonth() + b * j[O]);
                    if (d) {
                        a.setDate(e)
                    }
                    return a
                };
                if (f._since) {
                    i = p(i, -1, l)
                } else {
                    h = p(new Date(h.getTime()), +1, k)
                }
            }
            var q = Math.floor((i.getTime() - h.getTime()) / 1000);
            var r = function (a, b) {
                j[a] = (g[a] ? Math.floor(q / b) : 0);
                q -= j[a] * b
            };
            r(W, 604800);
            r(D, 86400);
            r(H, 3600);
            r(M, 60);
            r(S, 1);
            if (q > 0 && !f._since) {
                var s = [1, 12, 4.3482, 7, 24, 60, 60];
                var t = S;
                var u = 1;
                for (var v = S; v >= Y; v--) {
                    if (g[v]) {
                        if (j[t] >= u) {
                            j[t] = 0;
                            q = 1
                        }
                        if (q > 0) {
                            j[v]++;
                            q = 0;
                            t = v;
                            u = 1
                        }
                    }
                    u *= s[v]
                }
            }
            return j
        }
    });

    function extendRemove(a, b) {
        $.extend(a, b);
        for (var c in b) {
            if (b[c] == null) {
                a[c] = null
            }
        }
        return a
    }
    $.fn.countdown = function (a) {
        var b = Array.prototype.slice.call(arguments, 1);
        if (a == 'getTimes' || a == 'settings') {
            return $.countdown['_' + a + 'Countdown'].apply($.countdown, [this[0]].concat(b))
        }
        return this.each(function () {
            if (typeof a == 'string') {
                $.countdown['_' + a + 'Countdown'].apply($.countdown, [this].concat(b))
            } else {
                $.countdown._attachCountdown(this, a)
            }
        })
    };
    $.countdown = new Countdown()
})(jQuery);;
(function (c, j) {
    function k(a) {
        return !c(a).parents().andSelf().filter(function () {
            return c.curCSS(this, "visibility") === "hidden" || c.expr.filters.hidden(this)
        }).length
    }
    c.ui = c.ui || {};
    if (!c.ui.version) {
        c.extend(c.ui, {
            version: "1.8.12",
            keyCode: {
                ALT: 18,
                BACKSPACE: 8,
                CAPS_LOCK: 20,
                COMMA: 188,
                COMMAND: 91,
                COMMAND_LEFT: 91,
                COMMAND_RIGHT: 93,
                CONTROL: 17,
                DELETE: 46,
                DOWN: 40,
                END: 35,
                ENTER: 13,
                ESCAPE: 27,
                HOME: 36,
                INSERT: 45,
                LEFT: 37,
                MENU: 93,
                NUMPAD_ADD: 107,
                NUMPAD_DECIMAL: 110,
                NUMPAD_DIVIDE: 111,
                NUMPAD_ENTER: 108,
                NUMPAD_MULTIPLY: 106,
                NUMPAD_SUBTRACT: 109,
                PAGE_DOWN: 34,
                PAGE_UP: 33,
                PERIOD: 190,
                RIGHT: 39,
                SHIFT: 16,
                SPACE: 32,
                TAB: 9,
                UP: 38,
                WINDOWS: 91
            }
        });
        c.fn.extend({
            _focus: c.fn.focus,
            focus: function (a, b) {
                return typeof a === "number" ? this.each(function () {
                    var d = this;
                    setTimeout(function () {
                        c(d).focus();
                        b && b.call(d)
                    }, a)
                }) : this._focus.apply(this, arguments)
            },
            scrollParent: function () {
                var a;
                a = c.browser.msie && /(static|relative)/.test(this.css("position")) || /absolute/.test(this.css("position")) ? this.parents().filter(function () {
                    return /(relative|absolute|fixed)/.test(c.curCSS(this, "position", 1)) && /(auto|scroll)/.test(c.curCSS(this, "overflow", 1) + c.curCSS(this, "overflow-y", 1) + c.curCSS(this, "overflow-x", 1))
                }).eq(0) : this.parents().filter(function () {
                    return /(auto|scroll)/.test(c.curCSS(this, "overflow", 1) + c.curCSS(this, "overflow-y", 1) + c.curCSS(this, "overflow-x", 1))
                }).eq(0);
                return /fixed/.test(this.css("position")) || !a.length ? c(document) : a
            },
            zIndex: function (a) {
                if (a !== j) return this.css("zIndex", a);
                if (this.length) {
                    a = c(this[0]);
                    for (var b; a.length && a[0] !== document;) {
                        b = a.css("position");
                        if (b === "absolute" || b === "relative" || b === "fixed") {
                            b = parseInt(a.css("zIndex"), 10);
                            if (!isNaN(b) && b !== 0) return b
                        }
                        a = a.parent()
                    }
                }
                return 0
            },
            disableSelection: function () {
                return this.bind((c.support.selectstart ? "selectstart" : "mousedown") + ".ui-disableSelection", function (a) {
                    a.preventDefault()
                })
            },
            enableSelection: function () {
                return this.unbind(".ui-disableSelection")
            }
        });
        c.each(["Width", "Height"], function (a, b) {
            function d(f, g, l, m) {
                c.each(e, function () {
                    g -= parseFloat(c.curCSS(f, "padding" + this, true)) || 0;
                    if (l) g -= parseFloat(c.curCSS(f, "border" + this + "Width", true)) || 0;
                    if (m) g -= parseFloat(c.curCSS(f, "margin" + this, true)) || 0
                });
                return g
            }
            var e = b === "Width" ? ["Left", "Right"] : ["Top", "Bottom"],
                h = b.toLowerCase(),
                i = {
                    innerWidth: c.fn.innerWidth,
                    innerHeight: c.fn.innerHeight,
                    outerWidth: c.fn.outerWidth,
                    outerHeight: c.fn.outerHeight
                };
            c.fn["inner" + b] = function (f) {
                if (f === j) return i["inner" + b].call(this);
                return this.each(function () {
                    c(this).css(h, d(this, f) + "px")
                })
            };
            c.fn["outer" + b] = function (f, g) {
                if (typeof f !== "number") return i["outer" + b].call(this, f);
                return this.each(function () {
                    c(this).css(h, d(this, f, true, g) + "px")
                })
            }
        });
        c.extend(c.expr[":"], {
            data: function (a, b, d) {
                return !!c.data(a, d[3])
            },
            focusable: function (a) {
                var b = a.nodeName.toLowerCase(),
                    d = c.attr(a, "tabindex");
                if ("area" === b) {
                    b = a.parentNode;
                    d = b.name;
                    if (!a.href || !d || b.nodeName.toLowerCase() !== "map") return false;
                    a = c("img[usemap=#" + d + "]")[0];
                    return !!a && k(a)
                }
                return (/input|select|textarea|button|object/.test(b) ? !a.disabled : "a" == b ? a.href || !isNaN(d) : !isNaN(d)) && k(a)
            },
            tabbable: function (a) {
                var b = c.attr(a, "tabindex");
                return (isNaN(b) || b >= 0) && c(a).is(":focusable")
            }
        });
        c(function () {
            var a = document.body,
                b = a.appendChild(b = document.createElement("div"));
            c.extend(b.style, {
                minHeight: "100px",
                height: "auto",
                padding: 0,
                borderWidth: 0
            });
            c.support.minHeight = b.offsetHeight === 100;
            c.support.selectstart = "onselectstart" in b;
            a.removeChild(b).style.display = "none"
        });
        c.extend(c.ui, {
            plugin: {
                add: function (a, b, d) {
                    a = c.ui[a].prototype;
                    for (var e in d) {
                        a.plugins[e] = a.plugins[e] || [];
                        a.plugins[e].push([b, d[e]])
                    }
                },
                call: function (a, b, d) {
                    if ((b = a.plugins[b]) && a.element[0].parentNode) for (var e = 0; e < b.length; e++) a.options[b[e][0]] && b[e][1].apply(a.element, d)
                }
            },
            contains: function (a, b) {
                return document.compareDocumentPosition ? a.compareDocumentPosition(b) & 16 : a !== b && a.contains(b)
            },
            hasScroll: function (a, b) {
                if (c(a).css("overflow") === "hidden") return false;
                b = b && b === "left" ? "scrollLeft" : "scrollTop";
                var d = false;
                if (a[b] > 0) return true;
                a[b] = 1;
                d = a[b] > 0;
                a[b] = 0;
                return d
            },
            isOverAxis: function (a, b, d) {
                return a > b && a < b + d
            },
            isOver: function (a, b, d, e, h, i) {
                return c.ui.isOverAxis(a, d, h) && c.ui.isOverAxis(b, e, i)
            }
        })
    }
})(jQuery);;
(function (b, j) {
    if (b.cleanData) {
        var k = b.cleanData;
        b.cleanData = function (a) {
            for (var c = 0, d;
            (d = a[c]) != null; c++) b(d).triggerHandler("remove");
            k(a)
        }
    } else {
        var l = b.fn.remove;
        b.fn.remove = function (a, c) {
            return this.each(function () {
                if (!c) if (!a || b.filter(a, [this]).length) b("*", this).add([this]).each(function () {
                            b(this).triggerHandler("remove")
                        });
                return l.call(b(this), a, c)
            })
        }
    }
    b.widget = function (a, c, d) {
        var e = a.split(".")[0],
            f;
        a = a.split(".")[1];
        f = e + "-" + a;
        if (!d) {
            d = c;
            c = b.Widget
        }
        b.expr[":"][f] = function (h) {
            return !!b.data(h, a)
        };
        b[e] = b[e] || {};
        b[e][a] = function (h, g) {
            arguments.length && this._createWidget(h, g)
        };
        c = new c;
        c.options = b.extend(true, {}, c.options);
        b[e][a].prototype = b.extend(true, c, {
            namespace: e,
            widgetName: a,
            widgetEventPrefix: b[e][a].prototype.widgetEventPrefix || a,
            widgetBaseClass: f
        }, d);
        b.widget.bridge(a, b[e][a])
    };
    b.widget.bridge = function (a, c) {
        b.fn[a] = function (d) {
            var e = typeof d === "string",
                f = Array.prototype.slice.call(arguments, 1),
                h = this;
            d = !e && f.length ? b.extend.apply(null, [true, d].concat(f)) : d;
            if (e && d.charAt(0) === "_") return h;
            e ? this.each(function () {
                var g = b.data(this, a),
                    i = g && b.isFunction(g[d]) ? g[d].apply(g, f) : g;
                if (i !== g && i !== j) {
                    h = i;
                    return false
                }
            }) : this.each(function () {
                var g = b.data(this, a);
                g ? g.option(d || {})._init() : b.data(this, a, new c(d, this))
            });
            return h
        }
    };
    b.Widget = function (a, c) {
        arguments.length && this._createWidget(a, c)
    };
    b.Widget.prototype = {
        widgetName: "widget",
        widgetEventPrefix: "",
        options: {
            disabled: false
        },
        _createWidget: function (a, c) {
            b.data(c, this.widgetName, this);
            this.element = b(c);
            this.options = b.extend(true, {}, this.options, this._getCreateOptions(), a);
            var d = this;
            this.element.bind("remove." + this.widgetName, function () {
                d.destroy()
            });
            this._create();
            this._trigger("create");
            this._init()
        },
        _getCreateOptions: function () {
            return b.metadata && b.metadata.get(this.element[0])[this.widgetName]
        },
        _create: function () {},
        _init: function () {},
        destroy: function () {
            this.element.unbind("." + this.widgetName).removeData(this.widgetName);
            this.widget().unbind("." + this.widgetName).removeAttr("aria-disabled").removeClass(this.widgetBaseClass + "-disabled ui-state-disabled")
        },
        widget: function () {
            return this.element
        },
        option: function (a, c) {
            var d = a;
            if (arguments.length === 0) return b.extend({}, this.options);
            if (typeof a === "string") {
                if (c === j) return this.options[a];
                d = {};
                d[a] = c
            }
            this._setOptions(d);
            return this
        },
        _setOptions: function (a) {
            var c = this;
            b.each(a, function (d, e) {
                c._setOption(d, e)
            });
            return this
        },
        _setOption: function (a, c) {
            this.options[a] = c;
            if (a === "disabled") this.widget()[c ? "addClass" : "removeClass"](this.widgetBaseClass + "-disabled ui-state-disabled").attr("aria-disabled", c);
            return this
        },
        enable: function () {
            return this._setOption("disabled", false)
        },
        disable: function () {
            return this._setOption("disabled", true)
        },
        _trigger: function (a, c, d) {
            var e = this.options[a];
            c = b.Event(c);
            c.type = (a === this.widgetEventPrefix ? a : this.widgetEventPrefix + a).toLowerCase();
            d = d || {};
            if (c.originalEvent) {
                a = b.event.props.length;
                for (var f; a;) {
                    f = b.event.props[--a];
                    c[f] = c.originalEvent[f]
                }
            }
            this.element.trigger(c, d);
            return !(b.isFunction(e) && e.call(this.element[0], c, d) === false || c.isDefaultPrevented())
        }
    }
})(jQuery);;
(function (b) {
    b.widget("ui.mouse", {
        options: {
            cancel: ":input,option",
            distance: 1,
            delay: 0
        },
        _mouseInit: function () {
            var a = this;
            this.element.bind("mousedown." + this.widgetName, function (c) {
                return a._mouseDown(c)
            }).bind("click." + this.widgetName, function (c) {
                if (true === b.data(c.target, a.widgetName + ".preventClickEvent")) {
                    b.removeData(c.target, a.widgetName + ".preventClickEvent");
                    c.stopImmediatePropagation();
                    return false
                }
            });
            this.started = false
        },
        _mouseDestroy: function () {
            this.element.unbind("." + this.widgetName)
        },
        _mouseDown: function (a) {
            a.originalEvent = a.originalEvent || {};
            if (!a.originalEvent.mouseHandled) {
                this._mouseStarted && this._mouseUp(a);
                this._mouseDownEvent = a;
                var c = this,
                    e = a.which == 1,
                    f = typeof this.options.cancel == "string" ? b(a.target).parents().add(a.target).filter(this.options.cancel).length : false;
                if (!e || f || !this._mouseCapture(a)) return true;
                this.mouseDelayMet = !this.options.delay;
                if (!this.mouseDelayMet) this._mouseDelayTimer = setTimeout(function () {
                        c.mouseDelayMet = true
                    }, this.options.delay);
                if (this._mouseDistanceMet(a) && this._mouseDelayMet(a)) {
                    this._mouseStarted = this._mouseStart(a) !== false;
                    if (!this._mouseStarted) {
                        a.preventDefault();
                        return true
                    }
                }
                true === b.data(a.target, this.widgetName + ".preventClickEvent") && b.removeData(a.target, this.widgetName + ".preventClickEvent");
                this._mouseMoveDelegate = function (d) {
                    return c._mouseMove(d)
                };
                this._mouseUpDelegate = function (d) {
                    return c._mouseUp(d)
                };
                b(document).bind("mousemove." + this.widgetName, this._mouseMoveDelegate).bind("mouseup." + this.widgetName, this._mouseUpDelegate);
                a.preventDefault();
                return a.originalEvent.mouseHandled = true
            }
        },
        _mouseMove: function (a) {
            if (b.browser.msie && !(document.documentMode >= 9) && !a.button) return this._mouseUp(a);
            if (this._mouseStarted) {
                this._mouseDrag(a);
                return a.preventDefault()
            }
            if (this._mouseDistanceMet(a) && this._mouseDelayMet(a))(this._mouseStarted = this._mouseStart(this._mouseDownEvent, a) !== false) ? this._mouseDrag(a) : this._mouseUp(a);
            return !this._mouseStarted
        },
        _mouseUp: function (a) {
            b(document).unbind("mousemove." + this.widgetName, this._mouseMoveDelegate).unbind("mouseup." + this.widgetName, this._mouseUpDelegate);
            if (this._mouseStarted) {
                this._mouseStarted = false;
                a.target == this._mouseDownEvent.target && b.data(a.target, this.widgetName + ".preventClickEvent", true);
                this._mouseStop(a)
            }
            return false
        },
        _mouseDistanceMet: function (a) {
            return Math.max(Math.abs(this._mouseDownEvent.pageX - a.pageX), Math.abs(this._mouseDownEvent.pageY - a.pageY)) >= this.options.distance
        },
        _mouseDelayMet: function () {
            return this.mouseDelayMet
        },
        _mouseStart: function () {},
        _mouseDrag: function () {},
        _mouseStop: function () {},
        _mouseCapture: function () {
            return true
        }
    })
})(jQuery);;
(function (c) {
    c.ui = c.ui || {};
    var n = /left|center|right/,
        o = /top|center|bottom/,
        t = c.fn.position,
        u = c.fn.offset;
    c.fn.position = function (b) {
        if (!b || !b.of) return t.apply(this, arguments);
        b = c.extend({}, b);
        var a = c(b.of),
            d = a[0],
            g = (b.collision || "flip").split(" "),
            e = b.offset ? b.offset.split(" ") : [0, 0],
            h, k, j;
        if (d.nodeType === 9) {
            h = a.width();
            k = a.height();
            j = {
                top: 0,
                left: 0
            }
        } else if (d.setTimeout) {
            h = a.width();
            k = a.height();
            j = {
                top: a.scrollTop(),
                left: a.scrollLeft()
            }
        } else if (d.preventDefault) {
            b.at = "left top";
            h = k = 0;
            j = {
                top: b.of.pageY,
                left: b.of.pageX
            }
        } else {
            h = a.outerWidth();
            k = a.outerHeight();
            j = a.offset()
        }
        c.each(["my", "at"], function () {
            var f = (b[this] || "").split(" ");
            if (f.length === 1) f = n.test(f[0]) ? f.concat(["center"]) : o.test(f[0]) ? ["center"].concat(f) : ["center", "center"];
            f[0] = n.test(f[0]) ? f[0] : "center";
            f[1] = o.test(f[1]) ? f[1] : "center";
            b[this] = f
        });
        if (g.length === 1) g[1] = g[0];
        e[0] = parseInt(e[0], 10) || 0;
        if (e.length === 1) e[1] = e[0];
        e[1] = parseInt(e[1], 10) || 0;
        if (b.at[0] === "right") j.left += h;
        else if (b.at[0] === "center") j.left += h / 2;
        if (b.at[1] === "bottom") j.top += k;
        else if (b.at[1] === "center") j.top += k / 2;
        j.left += e[0];
        j.top += e[1];
        return this.each(function () {
            var f = c(this),
                l = f.outerWidth(),
                m = f.outerHeight(),
                p = parseInt(c.curCSS(this, "marginLeft", true)) || 0,
                q = parseInt(c.curCSS(this, "marginTop", true)) || 0,
                v = l + p + (parseInt(c.curCSS(this, "marginRight", true)) || 0),
                w = m + q + (parseInt(c.curCSS(this, "marginBottom", true)) || 0),
                i = c.extend({}, j),
                r;
            if (b.my[0] === "right") i.left -= l;
            else if (b.my[0] === "center") i.left -= l / 2;
            if (b.my[1] === "bottom") i.top -= m;
            else if (b.my[1] === "center") i.top -= m / 2;
            i.left = Math.round(i.left);
            i.top = Math.round(i.top);
            r = {
                left: i.left - p,
                top: i.top - q
            };
            c.each(["left", "top"], function (s, x) {
                c.ui.position[g[s]] && c.ui.position[g[s]][x](i, {
                    targetWidth: h,
                    targetHeight: k,
                    elemWidth: l,
                    elemHeight: m,
                    collisionPosition: r,
                    collisionWidth: v,
                    collisionHeight: w,
                    offset: e,
                    my: b.my,
                    at: b.at
                })
            });
            c.fn.bgiframe && f.bgiframe();
            f.offset(c.extend(i, {
                using: b.using
            }))
        })
    };
    c.ui.position = {
        fit: {
            left: function (b, a) {
                var d = c(window);
                d = a.collisionPosition.left + a.collisionWidth - d.width() - d.scrollLeft();
                b.left = d > 0 ? b.left - d : Math.max(b.left - a.collisionPosition.left, b.left)
            },
            top: function (b, a) {
                var d = c(window);
                d = a.collisionPosition.top + a.collisionHeight - d.height() - d.scrollTop();
                b.top = d > 0 ? b.top - d : Math.max(b.top - a.collisionPosition.top, b.top)
            }
        },
        flip: {
            left: function (b, a) {
                if (a.at[0] !== "center") {
                    var d = c(window);
                    d = a.collisionPosition.left + a.collisionWidth - d.width() - d.scrollLeft();
                    var g = a.my[0] === "left" ? -a.elemWidth : a.my[0] === "right" ? a.elemWidth : 0,
                        e = a.at[0] === "left" ? a.targetWidth : -a.targetWidth,
                        h = -2 * a.offset[0];
                    b.left += a.collisionPosition.left < 0 ? g + e + h : d > 0 ? g + e + h : 0
                }
            },
            top: function (b, a) {
                if (a.at[1] !== "center") {
                    var d = c(window);
                    d = a.collisionPosition.top + a.collisionHeight - d.height() - d.scrollTop();
                    var g = a.my[1] === "top" ? -a.elemHeight : a.my[1] === "bottom" ? a.elemHeight : 0,
                        e = a.at[1] === "top" ? a.targetHeight : -a.targetHeight,
                        h = -2 * a.offset[1];
                    b.top += a.collisionPosition.top < 0 ? g + e + h : d > 0 ? g + e + h : 0
                }
            }
        }
    };
    if (!c.offset.setOffset) {
        c.offset.setOffset = function (b, a) {
            if (/static/.test(c.curCSS(b, "position"))) b.style.position = "relative";
            var d = c(b),
                g = d.offset(),
                e = parseInt(c.curCSS(b, "top", true), 10) || 0,
                h = parseInt(c.curCSS(b, "left", true), 10) || 0;
            g = {
                top: a.top - g.top + e,
                left: a.left - g.left + h
            };
            "using" in a ? a.using.call(b, g) : d.css(g)
        };
        c.fn.offset = function (b) {
            var a = this[0];
            if (!a || !a.ownerDocument) return null;
            if (b) return this.each(function () {
                    c.offset.setOffset(this, b)
                });
            return u.call(this)
        }
    }
})(jQuery);;
(function (d) {
    d.widget("ui.draggable", d.ui.mouse, {
        widgetEventPrefix: "drag",
        options: {
            addClasses: true,
            appendTo: "parent",
            axis: false,
            connectToSortable: false,
            containment: false,
            cursor: "auto",
            cursorAt: false,
            grid: false,
            handle: false,
            helper: "original",
            iframeFix: false,
            opacity: false,
            refreshPositions: false,
            revert: false,
            revertDuration: 500,
            scope: "default",
            scroll: true,
            scrollSensitivity: 20,
            scrollSpeed: 20,
            snap: false,
            snapMode: "both",
            snapTolerance: 20,
            stack: false,
            zIndex: false
        },
        _create: function () {
            if (this.options.helper == "original" && !/^(?:r|a|f)/.test(this.element.css("position"))) this.element[0].style.position = "relative";
            this.options.addClasses && this.element.addClass("ui-draggable");
            this.options.disabled && this.element.addClass("ui-draggable-disabled");
            this._mouseInit()
        },
        destroy: function () {
            if (this.element.data("draggable")) {
                this.element.removeData("draggable").unbind(".draggable").removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled");
                this._mouseDestroy();
                return this
            }
        },
        _mouseCapture: function (a) {
            var b = this.options;
            if (this.helper || b.disabled || d(a.target).is(".ui-resizable-handle")) return false;
            this.handle = this._getHandle(a);
            if (!this.handle) return false;
            return true
        },
        _mouseStart: function (a) {
            var b = this.options;
            this.helper = this._createHelper(a);
            this._cacheHelperProportions();
            if (d.ui.ddmanager) d.ui.ddmanager.current = this;
            this._cacheMargins();
            this.cssPosition = this.helper.css("position");
            this.scrollParent = this.helper.scrollParent();
            this.offset = this.positionAbs = this.element.offset();
            this.offset = {
                top: this.offset.top - this.margins.top,
                left: this.offset.left - this.margins.left
            };
            d.extend(this.offset, {
                click: {
                    left: a.pageX - this.offset.left,
                    top: a.pageY - this.offset.top
                },
                parent: this._getParentOffset(),
                relative: this._getRelativeOffset()
            });
            this.originalPosition = this.position = this._generatePosition(a);
            this.originalPageX = a.pageX;
            this.originalPageY = a.pageY;
            b.cursorAt && this._adjustOffsetFromHelper(b.cursorAt);
            b.containment && this._setContainment();
            if (this._trigger("start", a) === false) {
                this._clear();
                return false
            }
            this._cacheHelperProportions();
            d.ui.ddmanager && !b.dropBehaviour && d.ui.ddmanager.prepareOffsets(this, a);
            this.helper.addClass("ui-draggable-dragging");
            this._mouseDrag(a, true);
            return true
        },
        _mouseDrag: function (a, b) {
            this.position = this._generatePosition(a);
            this.positionAbs = this._convertPositionTo("absolute");
            if (!b) {
                b = this._uiHash();
                if (this._trigger("drag", a, b) === false) {
                    this._mouseUp({});
                    return false
                }
                this.position = b.position
            }
            if (!this.options.axis || this.options.axis != "y") this.helper[0].style.left = this.position.left + "px";
            if (!this.options.axis || this.options.axis != "x") this.helper[0].style.top = this.position.top + "px";
            d.ui.ddmanager && d.ui.ddmanager.drag(this, a);
            return false
        },
        _mouseStop: function (a) {
            var b = false;
            if (d.ui.ddmanager && !this.options.dropBehaviour) b = d.ui.ddmanager.drop(this, a);
            if (this.dropped) {
                b = this.dropped;
                this.dropped = false
            }
            if ((!this.element[0] || !this.element[0].parentNode) && this.options.helper == "original") return false;
            if (this.options.revert == "invalid" && !b || this.options.revert == "valid" && b || this.options.revert === true || d.isFunction(this.options.revert) && this.options.revert.call(this.element, b)) {
                var c = this;
                d(this.helper).animate(this.originalPosition, parseInt(this.options.revertDuration, 10), function () {
                    c._trigger("stop", a) !== false && c._clear()
                })
            } else this._trigger("stop", a) !== false && this._clear();
            return false
        },
        cancel: function () {
            this.helper.is(".ui-draggable-dragging") ? this._mouseUp({}) : this._clear();
            return this
        },
        _getHandle: function (a) {
            var b = !this.options.handle || !d(this.options.handle, this.element).length ? true : false;
            d(this.options.handle, this.element).find("*").andSelf().each(function () {
                if (this == a.target) b = true
            });
            return b
        },
        _createHelper: function (a) {
            var b = this.options;
            a = d.isFunction(b.helper) ? d(b.helper.apply(this.element[0], [a])) : b.helper == "clone" ? this.element.clone() : this.element;
            a.parents("body").length || a.appendTo(b.appendTo == "parent" ? this.element[0].parentNode : b.appendTo);
            a[0] != this.element[0] && !/(fixed|absolute)/.test(a.css("position")) && a.css("position", "absolute");
            return a
        },
        _adjustOffsetFromHelper: function (a) {
            if (typeof a == "string") a = a.split(" ");
            if (d.isArray(a)) a = {
                    left: +a[0],
                    top: +a[1] || 0
            };
            if ("left" in a) this.offset.click.left = a.left + this.margins.left;
            if ("right" in a) this.offset.click.left = this.helperProportions.width - a.right + this.margins.left;
            if ("top" in a) this.offset.click.top = a.top + this.margins.top;
            if ("bottom" in a) this.offset.click.top = this.helperProportions.height - a.bottom + this.margins.top
        },
        _getParentOffset: function () {
            this.offsetParent = this.helper.offsetParent();
            var a = this.offsetParent.offset();
            if (this.cssPosition == "absolute" && this.scrollParent[0] != document && d.ui.contains(this.scrollParent[0], this.offsetParent[0])) {
                a.left += this.scrollParent.scrollLeft();
                a.top += this.scrollParent.scrollTop()
            }
            if (this.offsetParent[0] == document.body || this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == "html" && d.browser.msie) a = {
                    top: 0,
                    left: 0
            };
            return {
                top: a.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
                left: a.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
            }
        },
        _getRelativeOffset: function () {
            if (this.cssPosition == "relative") {
                var a = this.element.position();
                return {
                    top: a.top -
                        (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(),
                    left: a.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()
                }
            } else return {
                    top: 0,
                    left: 0
            }
        },
        _cacheMargins: function () {
            this.margins = {
                left: parseInt(this.element.css("marginLeft"), 10) || 0,
                top: parseInt(this.element.css("marginTop"), 10) || 0,
                right: parseInt(this.element.css("marginRight"), 10) || 0,
                bottom: parseInt(this.element.css("marginBottom"), 10) || 0
            }
        },
        _cacheHelperProportions: function () {
            this.helperProportions = {
                width: this.helper.outerWidth(),
                height: this.helper.outerHeight()
            }
        },
        _setContainment: function () {
            var a = this.options;
            if (a.containment == "parent") a.containment = this.helper[0].parentNode;
            if (a.containment == "document" || a.containment == "window") this.containment = [(a.containment == "document" ? 0 : d(window).scrollLeft()) - this.offset.relative.left - this.offset.parent.left, (a.containment == "document" ? 0 : d(window).scrollTop()) - this.offset.relative.top - this.offset.parent.top, (a.containment == "document" ? 0 : d(window).scrollLeft()) + d(a.containment == "document" ? document : window).width() - this.helperProportions.width - this.margins.left, (a.containment == "document" ? 0 : d(window).scrollTop()) + (d(a.containment == "document" ? document : window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top];
            if (!/^(document|window|parent)$/.test(a.containment) && a.containment.constructor != Array) {
                var b = d(a.containment)[0];
                if (b) {
                    a = d(a.containment).offset();
                    var c = d(b).css("overflow") != "hidden";
                    this.containment = [a.left + (parseInt(d(b).css("borderLeftWidth"), 10) || 0) + (parseInt(d(b).css("paddingLeft"), 10) || 0), a.top + (parseInt(d(b).css("borderTopWidth"), 10) || 0) + (parseInt(d(b).css("paddingTop"), 10) || 0), a.left + (c ? Math.max(b.scrollWidth, b.offsetWidth) : b.offsetWidth) - (parseInt(d(b).css("borderLeftWidth"), 10) || 0) - (parseInt(d(b).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left - this.margins.right, a.top + (c ? Math.max(b.scrollHeight, b.offsetHeight) : b.offsetHeight) - (parseInt(d(b).css("borderTopWidth"), 10) || 0) - (parseInt(d(b).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top - this.margins.bottom]
                }
            } else if (a.containment.constructor == Array) this.containment = a.containment
        },
        _convertPositionTo: function (a, b) {
            if (!b) b = this.position;
            a = a == "absolute" ? 1 : -1;
            var c = this.cssPosition == "absolute" && !(this.scrollParent[0] != document && d.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent,
                f = /(html|body)/i.test(c[0].tagName);
            return {
                top: b.top + this.offset.relative.top * a + this.offset.parent.top * a - (d.browser.safari && d.browser.version < 526 && this.cssPosition == "fixed" ? 0 : (this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : f ? 0 : c.scrollTop()) * a),
                left: b.left + this.offset.relative.left * a + this.offset.parent.left * a - (d.browser.safari && d.browser.version < 526 && this.cssPosition == "fixed" ? 0 : (this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : f ? 0 : c.scrollLeft()) * a)
            }
        },
        _generatePosition: function (a) {
            var b = this.options,
                c = this.cssPosition == "absolute" && !(this.scrollParent[0] != document && d.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent,
                f = /(html|body)/i.test(c[0].tagName),
                e = a.pageX,
                g = a.pageY;
            if (this.originalPosition) {
                if (this.containment) {
                    if (a.pageX - this.offset.click.left < this.containment[0]) e = this.containment[0] + this.offset.click.left;
                    if (a.pageY - this.offset.click.top < this.containment[1]) g = this.containment[1] + this.offset.click.top;
                    if (a.pageX - this.offset.click.left > this.containment[2]) e = this.containment[2] + this.offset.click.left;
                    if (a.pageY - this.offset.click.top > this.containment[3]) g = this.containment[3] + this.offset.click.top
                }
                if (b.grid) {
                    g = this.originalPageY + Math.round((g - this.originalPageY) / b.grid[1]) * b.grid[1];
                    g = this.containment ? !(g - this.offset.click.top < this.containment[1] || g - this.offset.click.top > this.containment[3]) ? g : !(g - this.offset.click.top < this.containment[1]) ? g - b.grid[1] : g + b.grid[1] : g;
                    e = this.originalPageX + Math.round((e - this.originalPageX) / b.grid[0]) * b.grid[0];
                    e = this.containment ? !(e - this.offset.click.left < this.containment[0] || e - this.offset.click.left > this.containment[2]) ? e : !(e - this.offset.click.left < this.containment[0]) ? e - b.grid[0] : e + b.grid[0] : e
                }
            }
            return {
                top: g - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + (d.browser.safari && d.browser.version < 526 && this.cssPosition == "fixed" ? 0 : this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : f ? 0 : c.scrollTop()),
                left: e - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + (d.browser.safari && d.browser.version < 526 && this.cssPosition == "fixed" ? 0 : this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : f ? 0 : c.scrollLeft())
            }
        },
        _clear: function () {
            this.helper.removeClass("ui-draggable-dragging");
            this.helper[0] != this.element[0] && !this.cancelHelperRemoval && this.helper.remove();
            this.helper = null;
            this.cancelHelperRemoval = false
        },
        _trigger: function (a, b, c) {
            c = c || this._uiHash();
            d.ui.plugin.call(this, a, [b, c]);
            if (a == "drag") this.positionAbs = this._convertPositionTo("absolute");
            return d.Widget.prototype._trigger.call(this, a, b, c)
        },
        plugins: {},
        _uiHash: function () {
            return {
                helper: this.helper,
                position: this.position,
                originalPosition: this.originalPosition,
                offset: this.positionAbs
            }
        }
    });
    d.extend(d.ui.draggable, {
        version: "1.8.12"
    });
    d.ui.plugin.add("draggable", "connectToSortable", {
        start: function (a, b) {
            var c = d(this).data("draggable"),
                f = c.options,
                e = d.extend({}, b, {
                    item: c.element
                });
            c.sortables = [];
            d(f.connectToSortable).each(function () {
                var g = d.data(this, "sortable");
                if (g && !g.options.disabled) {
                    c.sortables.push({
                        instance: g,
                        shouldRevert: g.options.revert
                    });
                    g.refreshPositions();
                    g._trigger("activate", a, e)
                }
            })
        },
        stop: function (a, b) {
            var c = d(this).data("draggable"),
                f = d.extend({}, b, {
                    item: c.element
                });
            d.each(c.sortables, function () {
                if (this.instance.isOver) {
                    this.instance.isOver = 0;
                    c.cancelHelperRemoval = true;
                    this.instance.cancelHelperRemoval = false;
                    if (this.shouldRevert) this.instance.options.revert = true;
                    this.instance._mouseStop(a);
                    this.instance.options.helper = this.instance.options._helper;
                    c.options.helper == "original" && this.instance.currentItem.css({
                        top: "auto",
                        left: "auto"
                    })
                } else {
                    this.instance.cancelHelperRemoval = false;
                    this.instance._trigger("deactivate", a, f)
                }
            })
        },
        drag: function (a, b) {
            var c = d(this).data("draggable"),
                f = this;
            d.each(c.sortables, function () {
                this.instance.positionAbs = c.positionAbs;
                this.instance.helperProportions = c.helperProportions;
                this.instance.offset.click = c.offset.click;
                if (this.instance._intersectsWith(this.instance.containerCache)) {
                    if (!this.instance.isOver) {
                        this.instance.isOver = 1;
                        this.instance.currentItem = d(f).clone().appendTo(this.instance.element).data("sortable-item", true);
                        this.instance.options._helper = this.instance.options.helper;
                        this.instance.options.helper = function () {
                            return b.helper[0]
                        };
                        a.target = this.instance.currentItem[0];
                        this.instance._mouseCapture(a, true);
                        this.instance._mouseStart(a, true, true);
                        this.instance.offset.click.top = c.offset.click.top;
                        this.instance.offset.click.left = c.offset.click.left;
                        this.instance.offset.parent.left -= c.offset.parent.left - this.instance.offset.parent.left;
                        this.instance.offset.parent.top -= c.offset.parent.top - this.instance.offset.parent.top;
                        c._trigger("toSortable", a);
                        c.dropped = this.instance.element;
                        c.currentItem = c.element;
                        this.instance.fromOutside = c
                    }
                    this.instance.currentItem && this.instance._mouseDrag(a)
                } else if (this.instance.isOver) {
                    this.instance.isOver = 0;
                    this.instance.cancelHelperRemoval = true;
                    this.instance.options.revert = false;
                    this.instance._trigger("out", a, this.instance._uiHash(this.instance));
                    this.instance._mouseStop(a, true);
                    this.instance.options.helper = this.instance.options._helper;
                    this.instance.currentItem.remove();
                    this.instance.placeholder && this.instance.placeholder.remove();
                    c._trigger("fromSortable", a);
                    c.dropped = false
                }
            })
        }
    });
    d.ui.plugin.add("draggable", "cursor", {
        start: function () {
            var a = d("body"),
                b = d(this).data("draggable").options;
            if (a.css("cursor")) b._cursor = a.css("cursor");
            a.css("cursor", b.cursor)
        },
        stop: function () {
            var a = d(this).data("draggable").options;
            a._cursor && d("body").css("cursor", a._cursor)
        }
    });
    d.ui.plugin.add("draggable", "iframeFix", {
        start: function () {
            var a = d(this).data("draggable").options;
            d(a.iframeFix === true ? "iframe" : a.iframeFix).each(function () {
                d('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({
                    width: this.offsetWidth + "px",
                    height: this.offsetHeight + "px",
                    position: "absolute",
                    opacity: "0.001",
                    zIndex: 1E3
                }).css(d(this).offset()).appendTo("body")
            })
        },
        stop: function () {
            d("div.ui-draggable-iframeFix").each(function () {
                this.parentNode.removeChild(this)
            })
        }
    });
    d.ui.plugin.add("draggable", "opacity", {
        start: function (a, b) {
            a = d(b.helper);
            b = d(this).data("draggable").options;
            if (a.css("opacity")) b._opacity = a.css("opacity");
            a.css("opacity", b.opacity)
        },
        stop: function (a, b) {
            a = d(this).data("draggable").options;
            a._opacity && d(b.helper).css("opacity", a._opacity)
        }
    });
    d.ui.plugin.add("draggable", "scroll", {
        start: function () {
            var a = d(this).data("draggable");
            if (a.scrollParent[0] != document && a.scrollParent[0].tagName != "HTML") a.overflowOffset = a.scrollParent.offset()
        },
        drag: function (a) {
            var b = d(this).data("draggable"),
                c = b.options,
                f = false;
            if (b.scrollParent[0] != document && b.scrollParent[0].tagName != "HTML") {
                if (!c.axis || c.axis != "x") if (b.overflowOffset.top + b.scrollParent[0].offsetHeight - a.pageY < c.scrollSensitivity) b.scrollParent[0].scrollTop = f = b.scrollParent[0].scrollTop +
                            c.scrollSpeed;
                    else if (a.pageY - b.overflowOffset.top < c.scrollSensitivity) b.scrollParent[0].scrollTop = f = b.scrollParent[0].scrollTop - c.scrollSpeed;
                if (!c.axis || c.axis != "y") if (b.overflowOffset.left + b.scrollParent[0].offsetWidth - a.pageX < c.scrollSensitivity) b.scrollParent[0].scrollLeft = f = b.scrollParent[0].scrollLeft + c.scrollSpeed;
                    else if (a.pageX - b.overflowOffset.left < c.scrollSensitivity) b.scrollParent[0].scrollLeft = f = b.scrollParent[0].scrollLeft - c.scrollSpeed
            } else {
                if (!c.axis || c.axis != "x") if (a.pageY - d(document).scrollTop() < c.scrollSensitivity) f = d(document).scrollTop(d(document).scrollTop() - c.scrollSpeed);
                    else if (d(window).height() - (a.pageY - d(document).scrollTop()) < c.scrollSensitivity) f = d(document).scrollTop(d(document).scrollTop() + c.scrollSpeed);
                if (!c.axis || c.axis != "y") if (a.pageX - d(document).scrollLeft() < c.scrollSensitivity) f = d(document).scrollLeft(d(document).scrollLeft() - c.scrollSpeed);
                    else if (d(window).width() - (a.pageX - d(document).scrollLeft()) < c.scrollSensitivity) f = d(document).scrollLeft(d(document).scrollLeft() +
                        c.scrollSpeed)
            }
            f !== false && d.ui.ddmanager && !c.dropBehaviour && d.ui.ddmanager.prepareOffsets(b, a)
        }
    });
    d.ui.plugin.add("draggable", "snap", {
        start: function () {
            var a = d(this).data("draggable"),
                b = a.options;
            a.snapElements = [];
            d(b.snap.constructor != String ? b.snap.items || ":data(draggable)" : b.snap).each(function () {
                var c = d(this),
                    f = c.offset();
                this != a.element[0] && a.snapElements.push({
                    item: this,
                    width: c.outerWidth(),
                    height: c.outerHeight(),
                    top: f.top,
                    left: f.left
                })
            })
        },
        drag: function (a, b) {
            for (var c = d(this).data("draggable"), f = c.options, e = f.snapTolerance, g = b.offset.left, n = g + c.helperProportions.width, m = b.offset.top, o = m + c.helperProportions.height, h = c.snapElements.length - 1; h >= 0; h--) {
                var i = c.snapElements[h].left,
                    k = i + c.snapElements[h].width,
                    j = c.snapElements[h].top,
                    l = j + c.snapElements[h].height;
                if (i - e < g && g < k + e && j - e < m && m < l + e || i - e < g && g < k + e && j - e < o && o < l + e || i - e < n && n < k + e && j - e < m && m < l + e || i - e < n && n < k + e && j - e < o && o < l + e) {
                    if (f.snapMode != "inner") {
                        var p = Math.abs(j - o) <= e,
                            q = Math.abs(l - m) <= e,
                            r = Math.abs(i - n) <= e,
                            s = Math.abs(k - g) <= e;
                        if (p) b.position.top = c._convertPositionTo("relative", {
                                top: j - c.helperProportions.height,
                                left: 0
                            }).top - c.margins.top;
                        if (q) b.position.top = c._convertPositionTo("relative", {
                                top: l,
                                left: 0
                            }).top - c.margins.top;
                        if (r) b.position.left = c._convertPositionTo("relative", {
                                top: 0,
                                left: i - c.helperProportions.width
                            }).left - c.margins.left;
                        if (s) b.position.left = c._convertPositionTo("relative", {
                                top: 0,
                                left: k
                            }).left - c.margins.left
                    }
                    var t = p || q || r || s;
                    if (f.snapMode != "outer") {
                        p = Math.abs(j - m) <= e;
                        q = Math.abs(l - o) <= e;
                        r = Math.abs(i - g) <= e;
                        s = Math.abs(k - n) <= e;
                        if (p) b.position.top = c._convertPositionTo("relative", {
                                top: j,
                                left: 0
                            }).top - c.margins.top;
                        if (q) b.position.top = c._convertPositionTo("relative", {
                                top: l - c.helperProportions.height,
                                left: 0
                            }).top - c.margins.top;
                        if (r) b.position.left = c._convertPositionTo("relative", {
                                top: 0,
                                left: i
                            }).left - c.margins.left;
                        if (s) b.position.left = c._convertPositionTo("relative", {
                                top: 0,
                                left: k - c.helperProportions.width
                            }).left - c.margins.left
                    }
                    if (!c.snapElements[h].snapping && (p || q || r || s || t)) c.options.snap.snap && c.options.snap.snap.call(c.element, a, d.extend(c._uiHash(), {
                            snapItem: c.snapElements[h].item
                        }));
                    c.snapElements[h].snapping = p || q || r || s || t
                } else {
                    c.snapElements[h].snapping && c.options.snap.release && c.options.snap.release.call(c.element, a, d.extend(c._uiHash(), {
                        snapItem: c.snapElements[h].item
                    }));
                    c.snapElements[h].snapping = false
                }
            }
        }
    });
    d.ui.plugin.add("draggable", "stack", {
        start: function () {
            var a = d(this).data("draggable").options;
            a = d.makeArray(d(a.stack)).sort(function (c, f) {
                return (parseInt(d(c).css("zIndex"), 10) || 0) - (parseInt(d(f).css("zIndex"), 10) || 0)
            });
            if (a.length) {
                var b = parseInt(a[0].style.zIndex) || 0;
                d(a).each(function (c) {
                    this.style.zIndex = b + c
                });
                this[0].style.zIndex = b + a.length
            }
        }
    });
    d.ui.plugin.add("draggable", "zIndex", {
        start: function (a, b) {
            a = d(b.helper);
            b = d(this).data("draggable").options;
            if (a.css("zIndex")) b._zIndex = a.css("zIndex");
            a.css("zIndex", b.zIndex)
        },
        stop: function (a, b) {
            a = d(this).data("draggable").options;
            a._zIndex && d(b.helper).css("zIndex", a._zIndex)
        }
    })
})(jQuery);;
(function (d) {
    d.widget("ui.droppable", {
        widgetEventPrefix: "drop",
        options: {
            accept: "*",
            activeClass: false,
            addClasses: true,
            greedy: false,
            hoverClass: false,
            scope: "default",
            tolerance: "intersect"
        },
        _create: function () {
            var a = this.options,
                b = a.accept;
            this.isover = 0;
            this.isout = 1;
            this.accept = d.isFunction(b) ? b : function (c) {
                return c.is(b)
            };
            this.proportions = {
                width: this.element[0].offsetWidth,
                height: this.element[0].offsetHeight
            };
            d.ui.ddmanager.droppables[a.scope] = d.ui.ddmanager.droppables[a.scope] || [];
            d.ui.ddmanager.droppables[a.scope].push(this);
            a.addClasses && this.element.addClass("ui-droppable")
        },
        destroy: function () {
            for (var a = d.ui.ddmanager.droppables[this.options.scope], b = 0; b < a.length; b++) a[b] == this && a.splice(b, 1);
            this.element.removeClass("ui-droppable ui-droppable-disabled").removeData("droppable").unbind(".droppable");
            return this
        },
        _setOption: function (a, b) {
            if (a == "accept") this.accept = d.isFunction(b) ? b : function (c) {
                    return c.is(b)
            };
            d.Widget.prototype._setOption.apply(this, arguments)
        },
        _activate: function (a) {
            var b = d.ui.ddmanager.current;
            this.options.activeClass && this.element.addClass(this.options.activeClass);
            b && this._trigger("activate", a, this.ui(b))
        },
        _deactivate: function (a) {
            var b = d.ui.ddmanager.current;
            this.options.activeClass && this.element.removeClass(this.options.activeClass);
            b && this._trigger("deactivate", a, this.ui(b))
        },
        _over: function (a) {
            var b = d.ui.ddmanager.current;
            if (!(!b || (b.currentItem || b.element)[0] == this.element[0])) if (this.accept.call(this.element[0], b.currentItem || b.element)) {
                    this.options.hoverClass && this.element.addClass(this.options.hoverClass);
                    this._trigger("over", a, this.ui(b))
                }
        },
        _out: function (a) {
            var b = d.ui.ddmanager.current;
            if (!(!b || (b.currentItem || b.element)[0] == this.element[0])) if (this.accept.call(this.element[0], b.currentItem || b.element)) {
                    this.options.hoverClass && this.element.removeClass(this.options.hoverClass);
                    this._trigger("out", a, this.ui(b))
                }
        },
        _drop: function (a, b) {
            var c = b || d.ui.ddmanager.current;
            if (!c || (c.currentItem || c.element)[0] == this.element[0]) return false;
            var e = false;
            this.element.find(":data(droppable)").not(".ui-draggable-dragging").each(function () {
                var g = d.data(this, "droppable");
                if (g.options.greedy && !g.options.disabled && g.options.scope == c.options.scope && g.accept.call(g.element[0], c.currentItem || c.element) && d.ui.intersect(c, d.extend(g, {
                    offset: g.element.offset()
                }), g.options.tolerance)) {
                    e = true;
                    return false
                }
            });
            if (e) return false;
            if (this.accept.call(this.element[0], c.currentItem || c.element)) {
                this.options.activeClass && this.element.removeClass(this.options.activeClass);
                this.options.hoverClass && this.element.removeClass(this.options.hoverClass);
                this._trigger("drop", a, this.ui(c));
                return this.element
            }
            return false
        },
        ui: function (a) {
            return {
                draggable: a.currentItem || a.element,
                helper: a.helper,
                position: a.position,
                offset: a.positionAbs
            }
        }
    });
    d.extend(d.ui.droppable, {
        version: "1.8.12"
    });
    d.ui.intersect = function (a, b, c) {
        if (!b.offset) return false;
        var e = (a.positionAbs || a.position.absolute).left,
            g = e + a.helperProportions.width,
            f = (a.positionAbs || a.position.absolute).top,
            h = f + a.helperProportions.height,
            i = b.offset.left,
            k = i + b.proportions.width,
            j = b.offset.top,
            l = j + b.proportions.height;
        switch (c) {
            case "fit":
                return i <= e && g <= k && j <= f && h <= l;
            case "intersect":
                return i < e + a.helperProportions.width / 2 && g - a.helperProportions.width / 2 < k && j < f + a.helperProportions.height / 2 && h - a.helperProportions.height / 2 < l;
            case "pointer":
                return d.ui.isOver((a.positionAbs || a.position.absolute).top + (a.clickOffset || a.offset.click).top, (a.positionAbs || a.position.absolute).left + (a.clickOffset || a.offset.click).left, j, i, b.proportions.height, b.proportions.width);
            case "touch":
                return (f >= j && f <= l || h >= j && h <= l || f < j && h > l) && (e >= i && e <= k || g >= i && g <= k || e < i && g > k);
            default:
                return false
        }
    };
    d.ui.ddmanager = {
        current: null,
        droppables: {
            "default": []
        },
        prepareOffsets: function (a, b) {
            var c = d.ui.ddmanager.droppables[a.options.scope] || [],
                e = b ? b.type : null,
                g = (a.currentItem || a.element).find(":data(droppable)").andSelf(),
                f = 0;
            a: for (; f < c.length; f++) if (!(c[f].options.disabled || a && !c[f].accept.call(c[f].element[0], a.currentItem || a.element))) {
                    for (var h = 0; h < g.length; h++) if (g[h] == c[f].element[0]) {
                            c[f].proportions.height = 0;
                            continue a
                        }
                    c[f].visible = c[f].element.css("display") != "none";
                    if (c[f].visible) {
                        e == "mousedown" && c[f]._activate.call(c[f], b);
                        c[f].offset = c[f].element.offset();
                        c[f].proportions = {
                            width: c[f].element[0].offsetWidth,
                            height: c[f].element[0].offsetHeight
                        }
                    }
                }
        },
        drop: function (a, b) {
            var c = false;
            d.each(d.ui.ddmanager.droppables[a.options.scope] || [], function () {
                if (this.options) {
                    if (!this.options.disabled && this.visible && d.ui.intersect(a, this, this.options.tolerance)) c = c || this._drop.call(this, b);
                    if (!this.options.disabled && this.visible && this.accept.call(this.element[0], a.currentItem || a.element)) {
                        this.isout = 1;
                        this.isover = 0;
                        this._deactivate.call(this, b)
                    }
                }
            });
            return c
        },
        drag: function (a, b) {
            a.options.refreshPositions && d.ui.ddmanager.prepareOffsets(a, b);
            d.each(d.ui.ddmanager.droppables[a.options.scope] || [], function () {
                if (!(this.options.disabled || this.greedyChild || !this.visible)) {
                    var c = d.ui.intersect(a, this, this.options.tolerance);
                    if (c = !c && this.isover == 1 ? "isout" : c && this.isover == 0 ? "isover" : null) {
                        var e;
                        if (this.options.greedy) {
                            var g = this.element.parents(":data(droppable):eq(0)");
                            if (g.length) {
                                e = d.data(g[0], "droppable");
                                e.greedyChild = c == "isover" ? 1 : 0
                            }
                        }
                        if (e && c == "isover") {
                            e.isover = 0;
                            e.isout = 1;
                            e._out.call(e, b)
                        }
                        this[c] = 1;
                        this[c == "isout" ? "isover" : "isout"] = 0;
                        this[c == "isover" ? "_over" : "_out"].call(this, b);
                        if (e && c == "isout") {
                            e.isout = 0;
                            e.isover = 1;
                            e._over.call(e, b)
                        }
                    }
                }
            })
        }
    }
})(jQuery);;
(function (e) {
    e.widget("ui.resizable", e.ui.mouse, {
        widgetEventPrefix: "resize",
        options: {
            alsoResize: false,
            animate: false,
            animateDuration: "slow",
            animateEasing: "swing",
            aspectRatio: false,
            autoHide: false,
            containment: false,
            ghost: false,
            grid: false,
            handles: "e,s,se",
            helper: false,
            maxHeight: null,
            maxWidth: null,
            minHeight: 10,
            minWidth: 10,
            zIndex: 1E3
        },
        _create: function () {
            var b = this,
                a = this.options;
            this.element.addClass("ui-resizable");
            e.extend(this, {
                _aspectRatio: !! a.aspectRatio,
                aspectRatio: a.aspectRatio,
                originalElement: this.element,
                _proportionallyResizeElements: [],
                _helper: a.helper || a.ghost || a.animate ? a.helper || "ui-resizable-helper" : null
            });
            if (this.element[0].nodeName.match(/canvas|textarea|input|select|button|img/i)) {
                /relative/.test(this.element.css("position")) && e.browser.opera && this.element.css({
                    position: "relative",
                    top: "auto",
                    left: "auto"
                });
                this.element.wrap(e('<div class="ui-wrapper" style="overflow: hidden;"></div>').css({
                    position: this.element.css("position"),
                    width: this.element.outerWidth(),
                    height: this.element.outerHeight(),
                    top: this.element.css("top"),
                    left: this.element.css("left")
                }));
                this.element = this.element.parent().data("resizable", this.element.data("resizable"));
                this.elementIsWrapper = true;
                this.element.css({
                    marginLeft: this.originalElement.css("marginLeft"),
                    marginTop: this.originalElement.css("marginTop"),
                    marginRight: this.originalElement.css("marginRight"),
                    marginBottom: this.originalElement.css("marginBottom")
                });
                this.originalElement.css({
                    marginLeft: 0,
                    marginTop: 0,
                    marginRight: 0,
                    marginBottom: 0
                });
                this.originalResizeStyle = this.originalElement.css("resize");
                this.originalElement.css("resize", "none");
                this._proportionallyResizeElements.push(this.originalElement.css({
                    position: "static",
                    zoom: 1,
                    display: "block"
                }));
                this.originalElement.css({
                    margin: this.originalElement.css("margin")
                });
                this._proportionallyResize()
            }
            this.handles = a.handles || (!e(".ui-resizable-handle", this.element).length ? "e,s,se" : {
                n: ".ui-resizable-n",
                e: ".ui-resizable-e",
                s: ".ui-resizable-s",
                w: ".ui-resizable-w",
                se: ".ui-resizable-se",
                sw: ".ui-resizable-sw",
                ne: ".ui-resizable-ne",
                nw: ".ui-resizable-nw"
            });
            if (this.handles.constructor == String) {
                if (this.handles == "all") this.handles = "n,e,s,w,se,sw,ne,nw";
                var c = this.handles.split(",");
                this.handles = {};
                for (var d = 0; d < c.length; d++) {
                    var f = e.trim(c[d]),
                        g = e('<div class="ui-resizable-handle ' + ("ui-resizable-" + f) + '"></div>');
                    /sw|se|ne|nw/.test(f) && g.css({
                        zIndex: ++a.zIndex
                    });
                    "se" == f && g.addClass("ui-icon ui-icon-gripsmall-diagonal-se");
                    this.handles[f] = ".ui-resizable-" + f;
                    this.element.append(g)
                }
            }
            this._renderAxis = function (h) {
                h = h || this.element;
                for (var i in this.handles) {
                    if (this.handles[i].constructor == String) this.handles[i] = e(this.handles[i], this.element).show();
                    if (this.elementIsWrapper && this.originalElement[0].nodeName.match(/textarea|input|select|button/i)) {
                        var j = e(this.handles[i], this.element),
                            k = 0;
                        k = /sw|ne|nw|se|n|s/.test(i) ? j.outerHeight() : j.outerWidth();
                        j = ["padding", /ne|nw|n/.test(i) ? "Top" : /se|sw|s/.test(i) ? "Bottom" : /^e$/.test(i) ? "Right" : "Left"].join("");
                        h.css(j, k);
                        this._proportionallyResize()
                    }
                    e(this.handles[i])
                }
            };
            this._renderAxis(this.element);
            this._handles = e(".ui-resizable-handle", this.element).disableSelection();
            this._handles.mouseover(function () {
                if (!b.resizing) {
                    if (this.className) var h = this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i);
                    b.axis = h && h[1] ? h[1] : "se"
                }
            });
            if (a.autoHide) {
                this._handles.hide();
                e(this.element).addClass("ui-resizable-autohide").hover(function () {
                    e(this).removeClass("ui-resizable-autohide");
                    b._handles.show()
                }, function () {
                    if (!b.resizing) {
                        e(this).addClass("ui-resizable-autohide");
                        b._handles.hide()
                    }
                })
            }
            this._mouseInit()
        },
        destroy: function () {
            this._mouseDestroy();
            var b = function (c) {
                e(c).removeClass("ui-resizable ui-resizable-disabled ui-resizable-resizing").removeData("resizable").unbind(".resizable").find(".ui-resizable-handle").remove()
            };
            if (this.elementIsWrapper) {
                b(this.element);
                var a = this.element;
                a.after(this.originalElement.css({
                    position: a.css("position"),
                    width: a.outerWidth(),
                    height: a.outerHeight(),
                    top: a.css("top"),
                    left: a.css("left")
                })).remove()
            }
            this.originalElement.css("resize", this.originalResizeStyle);
            b(this.originalElement);
            return this
        },
        _mouseCapture: function (b) {
            var a = false;
            for (var c in this.handles) if (e(this.handles[c])[0] == b.target) a = true;
            return !this.options.disabled && a
        },
        _mouseStart: function (b) {
            var a = this.options,
                c = this.element.position(),
                d = this.element;
            this.resizing = true;
            this.documentScroll = {
                top: e(document).scrollTop(),
                left: e(document).scrollLeft()
            };
            if (d.is(".ui-draggable") || /absolute/.test(d.css("position"))) d.css({
                    position: "absolute",
                    top: c.top,
                    left: c.left
                });
            e.browser.opera && /relative/.test(d.css("position")) && d.css({
                position: "relative",
                top: "auto",
                left: "auto"
            });
            this._renderProxy();
            c = m(this.helper.css("left"));
            var f = m(this.helper.css("top"));
            if (a.containment) {
                c += e(a.containment).scrollLeft() || 0;
                f += e(a.containment).scrollTop() || 0
            }
            this.offset = this.helper.offset();
            this.position = {
                left: c,
                top: f
            };
            this.size = this._helper ? {
                width: d.outerWidth(),
                height: d.outerHeight()
            } : {
                width: d.width(),
                height: d.height()
            };
            this.originalSize = this._helper ? {
                width: d.outerWidth(),
                height: d.outerHeight()
            } : {
                width: d.width(),
                height: d.height()
            };
            this.originalPosition = {
                left: c,
                top: f
            };
            this.sizeDiff = {
                width: d.outerWidth() - d.width(),
                height: d.outerHeight() - d.height()
            };
            this.originalMousePosition = {
                left: b.pageX,
                top: b.pageY
            };
            this.aspectRatio = typeof a.aspectRatio == "number" ? a.aspectRatio : this.originalSize.width / this.originalSize.height || 1;
            a = e(".ui-resizable-" + this.axis).css("cursor");
            e("body").css("cursor", a == "auto" ? this.axis + "-resize" : a);
            d.addClass("ui-resizable-resizing");
            this._propagate("start", b);
            return true
        },
        _mouseDrag: function (b) {
            var a = this.helper,
                c = this.originalMousePosition,
                d = this._change[this.axis];
            if (!d) return false;
            c = d.apply(this, [b, b.pageX - c.left || 0, b.pageY - c.top || 0]);
            if (this._aspectRatio || b.shiftKey) c = this._updateRatio(c, b);
            c = this._respectSize(c, b);
            this._propagate("resize", b);
            a.css({
                top: this.position.top + "px",
                left: this.position.left + "px",
                width: this.size.width + "px",
                height: this.size.height + "px"
            });
            !this._helper && this._proportionallyResizeElements.length && this._proportionallyResize();
            this._updateCache(c);
            this._trigger("resize", b, this.ui());
            return false
        },
        _mouseStop: function (b) {
            this.resizing = false;
            var a = this.options,
                c = this;
            if (this._helper) {
                var d = this._proportionallyResizeElements,
                    f = d.length && /textarea/i.test(d[0].nodeName);
                d = f && e.ui.hasScroll(d[0], "left") ? 0 : c.sizeDiff.height;
                f = f ? 0 : c.sizeDiff.width;
                f = {
                    width: c.helper.width() - f,
                    height: c.helper.height() - d
                };
                d = parseInt(c.element.css("left"), 10) + (c.position.left - c.originalPosition.left) || null;
                var g = parseInt(c.element.css("top"), 10) + (c.position.top - c.originalPosition.top) || null;
                a.animate || this.element.css(e.extend(f, {
                    top: g,
                    left: d
                }));
                c.helper.height(c.size.height);
                c.helper.width(c.size.width);
                this._helper && !a.animate && this._proportionallyResize()
            }
            e("body").css("cursor", "auto");
            this.element.removeClass("ui-resizable-resizing");
            this._propagate("stop", b);
            this._helper && this.helper.remove();
            return false
        },
        _updateCache: function (b) {
            this.offset = this.helper.offset();
            if (l(b.left)) this.position.left = b.left;
            if (l(b.top)) this.position.top = b.top;
            if (l(b.height)) this.size.height = b.height;
            if (l(b.width)) this.size.width = b.width
        },
        _updateRatio: function (b) {
            var a = this.position,
                c = this.size,
                d = this.axis;
            if (b.height) b.width = c.height * this.aspectRatio;
            else if (b.width) b.height = c.width / this.aspectRatio;
            if (d == "sw") {
                b.left = a.left + (c.width - b.width);
                b.top = null
            }
            if (d == "nw") {
                b.top = a.top + (c.height - b.height);
                b.left = a.left + (c.width - b.width)
            }
            return b
        },
        _respectSize: function (b) {
            var a = this.options,
                c = this.axis,
                d = l(b.width) && a.maxWidth && a.maxWidth < b.width,
                f = l(b.height) && a.maxHeight && a.maxHeight < b.height,
                g = l(b.width) && a.minWidth && a.minWidth > b.width,
                h = l(b.height) && a.minHeight && a.minHeight > b.height;
            if (g) b.width = a.minWidth;
            if (h) b.height = a.minHeight;
            if (d) b.width = a.maxWidth;
            if (f) b.height = a.maxHeight;
            var i = this.originalPosition.left + this.originalSize.width,
                j = this.position.top +
                    this.size.height,
                k = /sw|nw|w/.test(c);
            c = /nw|ne|n/.test(c);
            if (g && k) b.left = i - a.minWidth;
            if (d && k) b.left = i - a.maxWidth;
            if (h && c) b.top = j - a.minHeight;
            if (f && c) b.top = j - a.maxHeight;
            if ((a = !b.width && !b.height) && !b.left && b.top) b.top = null;
            else if (a && !b.top && b.left) b.left = null;
            return b
        },
        _proportionallyResize: function () {
            if (this._proportionallyResizeElements.length) for (var b = this.helper || this.element, a = 0; a < this._proportionallyResizeElements.length; a++) {
                    var c = this._proportionallyResizeElements[a];
                    if (!this.borderDif) {
                        var d = [c.css("borderTopWidth"), c.css("borderRightWidth"), c.css("borderBottomWidth"), c.css("borderLeftWidth")],
                            f = [c.css("paddingTop"), c.css("paddingRight"), c.css("paddingBottom"), c.css("paddingLeft")];
                        this.borderDif = e.map(d, function (g, h) {
                            g = parseInt(g, 10) || 0;
                            h = parseInt(f[h], 10) || 0;
                            return g + h
                        })
                    }
                    e.browser.msie && (e(b).is(":hidden") || e(b).parents(":hidden").length) || c.css({
                        height: b.height() - this.borderDif[0] - this.borderDif[2] || 0,
                        width: b.width() - this.borderDif[1] - this.borderDif[3] || 0
                    })
            }
        },
        _renderProxy: function () {
            var b = this.options;
            this.elementOffset = this.element.offset();
            if (this._helper) {
                this.helper = this.helper || e('<div style="overflow:hidden;"></div>');
                var a = e.browser.msie && e.browser.version < 7,
                    c = a ? 1 : 0;
                a = a ? 2 : -1;
                this.helper.addClass(this._helper).css({
                    width: this.element.outerWidth() + a,
                    height: this.element.outerHeight() + a,
                    position: "absolute",
                    left: this.elementOffset.left - c + "px",
                    top: this.elementOffset.top - c + "px",
                    zIndex: ++b.zIndex
                });
                this.helper.appendTo("body").disableSelection()
            } else this.helper = this.element
        },
        _change: {
            e: function (b, a) {
                return {
                    width: this.originalSize.width + a
                }
            },
            w: function (b, a) {
                return {
                    left: this.originalPosition.left + a,
                    width: this.originalSize.width - a
                }
            },
            n: function (b, a, c) {
                return {
                    top: this.originalPosition.top + c,
                    height: this.originalSize.height - c
                }
            },
            s: function (b, a, c) {
                return {
                    height: this.originalSize.height + c
                }
            },
            se: function (b, a, c) {
                return e.extend(this._change.s.apply(this, arguments), this._change.e.apply(this, [b, a, c]))
            },
            sw: function (b, a, c) {
                return e.extend(this._change.s.apply(this, arguments), this._change.w.apply(this, [b, a, c]))
            },
            ne: function (b, a, c) {
                return e.extend(this._change.n.apply(this, arguments), this._change.e.apply(this, [b, a, c]))
            },
            nw: function (b, a, c) {
                return e.extend(this._change.n.apply(this, arguments), this._change.w.apply(this, [b, a, c]))
            }
        },
        _propagate: function (b, a) {
            e.ui.plugin.call(this, b, [a, this.ui()]);
            b != "resize" && this._trigger(b, a, this.ui())
        },
        plugins: {},
        ui: function () {
            return {
                originalElement: this.originalElement,
                element: this.element,
                helper: this.helper,
                position: this.position,
                size: this.size,
                originalSize: this.originalSize,
                originalPosition: this.originalPosition
            }
        }
    });
    e.extend(e.ui.resizable, {
        version: "1.8.12"
    });
    e.ui.plugin.add("resizable", "alsoResize", {
        start: function () {
            var b = e(this).data("resizable").options,
                a = function (c) {
                    e(c).each(function () {
                        var d = e(this);
                        d.data("resizable-alsoresize", {
                            width: parseInt(d.width(), 10),
                            height: parseInt(d.height(), 10),
                            left: parseInt(d.css("left"), 10),
                            top: parseInt(d.css("top"), 10),
                            position: d.css("position")
                        })
                    })
                };
            if (typeof b.alsoResize == "object" && !b.alsoResize.parentNode) if (b.alsoResize.length) {
                    b.alsoResize = b.alsoResize[0];
                    a(b.alsoResize)
                } else e.each(b.alsoResize, function (c) {
                        a(c)
                    });
                else a(b.alsoResize)
        },
        resize: function (b, a) {
            var c = e(this).data("resizable");
            b = c.options;
            var d = c.originalSize,
                f = c.originalPosition,
                g = {
                    height: c.size.height - d.height || 0,
                    width: c.size.width - d.width || 0,
                    top: c.position.top - f.top || 0,
                    left: c.position.left - f.left || 0
                }, h = function (i, j) {
                    e(i).each(function () {
                        var k = e(this),
                            q = e(this).data("resizable-alsoresize"),
                            p = {}, r = j && j.length ? j : k.parents(a.originalElement[0]).length ? ["width", "height"] : ["width", "height", "top", "left"];
                        e.each(r, function (n, o) {
                            if ((n = (q[o] || 0) + (g[o] || 0)) && n >= 0) p[o] = n || null
                        });
                        if (e.browser.opera && /relative/.test(k.css("position"))) {
                            c._revertToRelativePosition = true;
                            k.css({
                                position: "absolute",
                                top: "auto",
                                left: "auto"
                            })
                        }
                        k.css(p)
                    })
                };
            typeof b.alsoResize == "object" && !b.alsoResize.nodeType ? e.each(b.alsoResize, function (i, j) {
                h(i, j)
            }) : h(b.alsoResize)
        },
        stop: function () {
            var b = e(this).data("resizable"),
                a = b.options,
                c = function (d) {
                    e(d).each(function () {
                        var f = e(this);
                        f.css({
                            position: f.data("resizable-alsoresize").position
                        })
                    })
                };
            if (b._revertToRelativePosition) {
                b._revertToRelativePosition = false;
                typeof a.alsoResize == "object" && !a.alsoResize.nodeType ? e.each(a.alsoResize, function (d) {
                    c(d)
                }) : c(a.alsoResize)
            }
            e(this).removeData("resizable-alsoresize")
        }
    });
    e.ui.plugin.add("resizable", "animate", {
        stop: function (b) {
            var a = e(this).data("resizable"),
                c = a.options,
                d = a._proportionallyResizeElements,
                f = d.length && /textarea/i.test(d[0].nodeName),
                g = f && e.ui.hasScroll(d[0], "left") ? 0 : a.sizeDiff.height;
            f = {
                width: a.size.width - (f ? 0 : a.sizeDiff.width),
                height: a.size.height - g
            };
            g = parseInt(a.element.css("left"), 10) + (a.position.left - a.originalPosition.left) || null;
            var h = parseInt(a.element.css("top"), 10) + (a.position.top - a.originalPosition.top) || null;
            a.element.animate(e.extend(f, h && g ? {
                top: h,
                left: g
            } : {}), {
                duration: c.animateDuration,
                easing: c.animateEasing,
                step: function () {
                    var i = {
                        width: parseInt(a.element.css("width"), 10),
                        height: parseInt(a.element.css("height"), 10),
                        top: parseInt(a.element.css("top"), 10),
                        left: parseInt(a.element.css("left"), 10)
                    };
                    d && d.length && e(d[0]).css({
                        width: i.width,
                        height: i.height
                    });
                    a._updateCache(i);
                    a._propagate("resize", b)
                }
            })
        }
    });
    e.ui.plugin.add("resizable", "containment", {
        start: function () {
            var b = e(this).data("resizable"),
                a = b.element,
                c = b.options.containment;
            if (a = c instanceof e ? c.get(0) : /parent/.test(c) ? a.parent().get(0) : c) {
                b.containerElement = e(a);
                if (/document/.test(c) || c == document) {
                    b.containerOffset = {
                        left: 0,
                        top: 0
                    };
                    b.containerPosition = {
                        left: 0,
                        top: 0
                    };
                    b.parentData = {
                        element: e(document),
                        left: 0,
                        top: 0,
                        width: e(document).width(),
                        height: e(document).height() || document.body.parentNode.scrollHeight
                    }
                } else {
                    var d = e(a),
                        f = [];
                    e(["Top", "Right", "Left", "Bottom"]).each(function (i, j) {
                        f[i] = m(d.css("padding" + j))
                    });
                    b.containerOffset = d.offset();
                    b.containerPosition = d.position();
                    b.containerSize = {
                        height: d.innerHeight() - f[3],
                        width: d.innerWidth() - f[1]
                    };
                    c = b.containerOffset;
                    var g = b.containerSize.height,
                        h = b.containerSize.width;
                    h = e.ui.hasScroll(a, "left") ? a.scrollWidth : h;
                    g = e.ui.hasScroll(a) ? a.scrollHeight : g;
                    b.parentData = {
                        element: a,
                        left: c.left,
                        top: c.top,
                        width: h,
                        height: g
                    }
                }
            }
        },
        resize: function (b) {
            var a = e(this).data("resizable"),
                c = a.options,
                d = a.containerOffset,
                f = a.position;
            b = a._aspectRatio || b.shiftKey;
            var g = {
                top: 0,
                left: 0
            }, h = a.containerElement;
            if (h[0] != document && /static/.test(h.css("position"))) g = d;
            if (f.left < (a._helper ? d.left : 0)) {
                a.size.width += a._helper ? a.position.left - d.left : a.position.left - g.left;
                if (b) a.size.height = a.size.width / c.aspectRatio;
                a.position.left = c.helper ? d.left : 0
            }
            if (f.top < (a._helper ? d.top : 0)) {
                a.size.height += a._helper ? a.position.top - d.top : a.position.top;
                if (b) a.size.width = a.size.height * c.aspectRatio;
                a.position.top = a._helper ? d.top : 0
            }
            a.offset.left = a.parentData.left + a.position.left;
            a.offset.top = a.parentData.top + a.position.top;
            c = Math.abs((a._helper ? a.offset.left - g.left : a.offset.left - g.left) + a.sizeDiff.width);
            d = Math.abs((a._helper ? a.offset.top - g.top : a.offset.top - d.top) + a.sizeDiff.height);
            f = a.containerElement.get(0) == a.element.parent().get(0);
            g = /relative|absolute/.test(a.containerElement.css("position"));
            if (f && g) c -= a.parentData.left;
            if (c + a.size.width >= a.parentData.width) {
                a.size.width = a.parentData.width - c;
                if (b) a.size.height = a.size.width / a.aspectRatio
            }
            if (d + a.size.height >= a.parentData.height) {
                a.size.height = a.parentData.height - d;
                if (b) a.size.width = a.size.height * a.aspectRatio
            }
        },
        stop: function () {
            var b = e(this).data("resizable"),
                a = b.options,
                c = b.containerOffset,
                d = b.containerPosition,
                f = b.containerElement,
                g = e(b.helper),
                h = g.offset(),
                i = g.outerWidth() - b.sizeDiff.width;
            g = g.outerHeight() - b.sizeDiff.height;
            b._helper && !a.animate && /relative/.test(f.css("position")) && e(this).css({
                left: h.left - d.left - c.left,
                width: i,
                height: g
            });
            b._helper && !a.animate && /static/.test(f.css("position")) && e(this).css({
                left: h.left - d.left - c.left,
                width: i,
                height: g
            })
        }
    });
    e.ui.plugin.add("resizable", "ghost", {
        start: function () {
            var b = e(this).data("resizable"),
                a = b.options,
                c = b.size;
            b.ghost = b.originalElement.clone();
            b.ghost.css({
                opacity: 0.25,
                display: "block",
                position: "relative",
                height: c.height,
                width: c.width,
                margin: 0,
                left: 0,
                top: 0
            }).addClass("ui-resizable-ghost").addClass(typeof a.ghost == "string" ? a.ghost : "");
            b.ghost.appendTo(b.helper)
        },
        resize: function () {
            var b = e(this).data("resizable");
            b.ghost && b.ghost.css({
                position: "relative",
                height: b.size.height,
                width: b.size.width
            })
        },
        stop: function () {
            var b = e(this).data("resizable");
            b.ghost && b.helper && b.helper.get(0).removeChild(b.ghost.get(0))
        }
    });
    e.ui.plugin.add("resizable", "grid", {
        resize: function () {
            var b = e(this).data("resizable"),
                a = b.options,
                c = b.size,
                d = b.originalSize,
                f = b.originalPosition,
                g = b.axis;
            a.grid = typeof a.grid == "number" ? [a.grid, a.grid] : a.grid;
            var h = Math.round((c.width - d.width) / (a.grid[0] || 1)) * (a.grid[0] || 1);
            a = Math.round((c.height - d.height) / (a.grid[1] || 1)) * (a.grid[1] || 1);
            if (/^(se|s|e)$/.test(g)) {
                b.size.width = d.width + h;
                b.size.height = d.height + a
            } else if (/^(ne)$/.test(g)) {
                b.size.width = d.width + h;
                b.size.height = d.height + a;
                b.position.top = f.top - a
            } else {
                if (/^(sw)$/.test(g)) {
                    b.size.width = d.width + h;
                    b.size.height = d.height + a
                } else {
                    b.size.width = d.width + h;
                    b.size.height = d.height + a;
                    b.position.top = f.top - a
                }
                b.position.left = f.left - h
            }
        }
    });
    var m = function (b) {
        return parseInt(b, 10) || 0
    }, l = function (b) {
            return !isNaN(parseInt(b, 10))
        }
})(jQuery);;
(function (e) {
    e.widget("ui.selectable", e.ui.mouse, {
        options: {
            appendTo: "body",
            autoRefresh: true,
            distance: 0,
            filter: "*",
            tolerance: "touch"
        },
        _create: function () {
            var c = this;
            this.element.addClass("ui-selectable");
            this.dragged = false;
            var f;
            this.refresh = function () {
                f = e(c.options.filter, c.element[0]);
                f.each(function () {
                    var d = e(this),
                        b = d.offset();
                    e.data(this, "selectable-item", {
                        element: this,
                        $element: d,
                        left: b.left,
                        top: b.top,
                        right: b.left + d.outerWidth(),
                        bottom: b.top + d.outerHeight(),
                        startselected: false,
                        selected: d.hasClass("ui-selected"),
                        selecting: d.hasClass("ui-selecting"),
                        unselecting: d.hasClass("ui-unselecting")
                    })
                })
            };
            this.refresh();
            this.selectees = f.addClass("ui-selectee");
            this._mouseInit();
            this.helper = e("<div class='ui-selectable-helper'></div>")
        },
        destroy: function () {
            this.selectees.removeClass("ui-selectee").removeData("selectable-item");
            this.element.removeClass("ui-selectable ui-selectable-disabled").removeData("selectable").unbind(".selectable");
            this._mouseDestroy();
            return this
        },
        _mouseStart: function (c) {
            var f = this;
            this.opos = [c.pageX, c.pageY];
            if (!this.options.disabled) {
                var d = this.options;
                this.selectees = e(d.filter, this.element[0]);
                this._trigger("start", c);
                e(d.appendTo).append(this.helper);
                this.helper.css({
                    left: c.clientX,
                    top: c.clientY,
                    width: 0,
                    height: 0
                });
                d.autoRefresh && this.refresh();
                this.selectees.filter(".ui-selected").each(function () {
                    var b = e.data(this, "selectable-item");
                    b.startselected = true;
                    if (!c.metaKey) {
                        b.$element.removeClass("ui-selected");
                        b.selected = false;
                        b.$element.addClass("ui-unselecting");
                        b.unselecting = true;
                        f._trigger("unselecting", c, {
                            unselecting: b.element
                        })
                    }
                });
                e(c.target).parents().andSelf().each(function () {
                    var b = e.data(this, "selectable-item");
                    if (b) {
                        var g = !c.metaKey || !b.$element.hasClass("ui-selected");
                        b.$element.removeClass(g ? "ui-unselecting" : "ui-selected").addClass(g ? "ui-selecting" : "ui-unselecting");
                        b.unselecting = !g;
                        b.selecting = g;
                        (b.selected = g) ? f._trigger("selecting", c, {
                            selecting: b.element
                        }) : f._trigger("unselecting", c, {
                            unselecting: b.element
                        });
                        return false
                    }
                })
            }
        },
        _mouseDrag: function (c) {
            var f = this;
            this.dragged = true;
            if (!this.options.disabled) {
                var d = this.options,
                    b = this.opos[0],
                    g = this.opos[1],
                    h = c.pageX,
                    i = c.pageY;
                if (b > h) {
                    var j = h;
                    h = b;
                    b = j
                }
                if (g > i) {
                    j = i;
                    i = g;
                    g = j
                }
                this.helper.css({
                    left: b,
                    top: g,
                    width: h - b,
                    height: i - g
                });
                this.selectees.each(function () {
                    var a = e.data(this, "selectable-item");
                    if (!(!a || a.element == f.element[0])) {
                        var k = false;
                        if (d.tolerance == "touch") k = !(a.left > h || a.right < b || a.top > i || a.bottom < g);
                        else if (d.tolerance == "fit") k = a.left > b && a.right < h && a.top > g && a.bottom < i;
                        if (k) {
                            if (a.selected) {
                                a.$element.removeClass("ui-selected");
                                a.selected = false
                            }
                            if (a.unselecting) {
                                a.$element.removeClass("ui-unselecting");
                                a.unselecting = false
                            }
                            if (!a.selecting) {
                                a.$element.addClass("ui-selecting");
                                a.selecting = true;
                                f._trigger("selecting", c, {
                                    selecting: a.element
                                })
                            }
                        } else {
                            if (a.selecting) if (c.metaKey && a.startselected) {
                                    a.$element.removeClass("ui-selecting");
                                    a.selecting = false;
                                    a.$element.addClass("ui-selected");
                                    a.selected = true
                                } else {
                                    a.$element.removeClass("ui-selecting");
                                    a.selecting = false;
                                    if (a.startselected) {
                                        a.$element.addClass("ui-unselecting");
                                        a.unselecting = true
                                    }
                                    f._trigger("unselecting", c, {
                                        unselecting: a.element
                                    })
                                }
                            if (a.selected) if (!c.metaKey && !a.startselected) {
                                    a.$element.removeClass("ui-selected");
                                    a.selected = false;
                                    a.$element.addClass("ui-unselecting");
                                    a.unselecting = true;
                                    f._trigger("unselecting", c, {
                                        unselecting: a.element
                                    })
                                }
                        }
                    }
                });
                return false
            }
        },
        _mouseStop: function (c) {
            var f = this;
            this.dragged = false;
            e(".ui-unselecting", this.element[0]).each(function () {
                var d = e.data(this, "selectable-item");
                d.$element.removeClass("ui-unselecting");
                d.unselecting = false;
                d.startselected = false;
                f._trigger("unselected", c, {
                    unselected: d.element
                })
            });
            e(".ui-selecting", this.element[0]).each(function () {
                var d = e.data(this, "selectable-item");
                d.$element.removeClass("ui-selecting").addClass("ui-selected");
                d.selecting = false;
                d.selected = true;
                d.startselected = true;
                f._trigger("selected", c, {
                    selected: d.element
                })
            });
            this._trigger("stop", c);
            this.helper.remove();
            return false
        }
    });
    e.extend(e.ui.selectable, {
        version: "1.8.12"
    })
})(jQuery);;
(function (d) {
    d.widget("ui.sortable", d.ui.mouse, {
        widgetEventPrefix: "sort",
        options: {
            appendTo: "parent",
            axis: false,
            connectWith: false,
            containment: false,
            cursor: "auto",
            cursorAt: false,
            dropOnEmpty: true,
            forcePlaceholderSize: false,
            forceHelperSize: false,
            grid: false,
            handle: false,
            helper: "original",
            items: "> *",
            opacity: false,
            placeholder: false,
            revert: false,
            scroll: true,
            scrollSensitivity: 20,
            scrollSpeed: 20,
            scope: "default",
            tolerance: "intersect",
            zIndex: 1E3
        },
        _create: function () {
            this.containerCache = {};
            this.element.addClass("ui-sortable");
            this.refresh();
            this.floating = this.items.length ? /left|right/.test(this.items[0].item.css("float")) || /inline|table-cell/.test(this.items[0].item.css("display")) : false;
            this.offset = this.element.offset();
            this._mouseInit()
        },
        destroy: function () {
            this.element.removeClass("ui-sortable ui-sortable-disabled").removeData("sortable").unbind(".sortable");
            this._mouseDestroy();
            for (var a = this.items.length - 1; a >= 0; a--) this.items[a].item.removeData("sortable-item");
            return this
        },
        _setOption: function (a, b) {
            if (a === "disabled") {
                this.options[a] = b;
                this.widget()[b ? "addClass" : "removeClass"]("ui-sortable-disabled")
            } else d.Widget.prototype._setOption.apply(this, arguments)
        },
        _mouseCapture: function (a, b) {
            if (this.reverting) return false;
            if (this.options.disabled || this.options.type == "static") return false;
            this._refreshItems(a);
            var c = null,
                e = this;
            d(a.target).parents().each(function () {
                if (d.data(this, "sortable-item") == e) {
                    c = d(this);
                    return false
                }
            });
            if (d.data(a.target, "sortable-item") == e) c = d(a.target);
            if (!c) return false;
            if (this.options.handle && !b) {
                var f = false;
                d(this.options.handle, c).find("*").andSelf().each(function () {
                    if (this == a.target) f = true
                });
                if (!f) return false
            }
            this.currentItem = c;
            this._removeCurrentsFromItems();
            return true
        },
        _mouseStart: function (a, b, c) {
            b = this.options;
            var e = this;
            this.currentContainer = this;
            this.refreshPositions();
            this.helper = this._createHelper(a);
            this._cacheHelperProportions();
            this._cacheMargins();
            this.scrollParent = this.helper.scrollParent();
            this.offset = this.currentItem.offset();
            this.offset = {
                top: this.offset.top - this.margins.top,
                left: this.offset.left - this.margins.left
            };
            this.helper.css("position", "absolute");
            this.cssPosition = this.helper.css("position");
            d.extend(this.offset, {
                click: {
                    left: a.pageX - this.offset.left,
                    top: a.pageY - this.offset.top
                },
                parent: this._getParentOffset(),
                relative: this._getRelativeOffset()
            });
            this.originalPosition = this._generatePosition(a);
            this.originalPageX = a.pageX;
            this.originalPageY = a.pageY;
            b.cursorAt && this._adjustOffsetFromHelper(b.cursorAt);
            this.domPosition = {
                prev: this.currentItem.prev()[0],
                parent: this.currentItem.parent()[0]
            };
            this.helper[0] != this.currentItem[0] && this.currentItem.hide();
            this._createPlaceholder();
            b.containment && this._setContainment();
            if (b.cursor) {
                if (d("body").css("cursor")) this._storedCursor = d("body").css("cursor");
                d("body").css("cursor", b.cursor)
            }
            if (b.opacity) {
                if (this.helper.css("opacity")) this._storedOpacity = this.helper.css("opacity");
                this.helper.css("opacity", b.opacity)
            }
            if (b.zIndex) {
                if (this.helper.css("zIndex")) this._storedZIndex = this.helper.css("zIndex");
                this.helper.css("zIndex", b.zIndex)
            }
            if (this.scrollParent[0] != document && this.scrollParent[0].tagName != "HTML") this.overflowOffset = this.scrollParent.offset();
            this._trigger("start", a, this._uiHash());
            this._preserveHelperProportions || this._cacheHelperProportions();
            if (!c) for (c = this.containers.length - 1; c >= 0; c--) this.containers[c]._trigger("activate", a, e._uiHash(this));
            if (d.ui.ddmanager) d.ui.ddmanager.current = this;
            d.ui.ddmanager && !b.dropBehaviour && d.ui.ddmanager.prepareOffsets(this, a);
            this.dragging = true;
            this.helper.addClass("ui-sortable-helper");
            this._mouseDrag(a);
            return true
        },
        _mouseDrag: function (a) {
            this.position = this._generatePosition(a);
            this.positionAbs = this._convertPositionTo("absolute");
            if (!this.lastPositionAbs) this.lastPositionAbs = this.positionAbs;
            if (this.options.scroll) {
                var b = this.options,
                    c = false;
                if (this.scrollParent[0] != document && this.scrollParent[0].tagName != "HTML") {
                    if (this.overflowOffset.top + this.scrollParent[0].offsetHeight - a.pageY < b.scrollSensitivity) this.scrollParent[0].scrollTop = c = this.scrollParent[0].scrollTop + b.scrollSpeed;
                    else if (a.pageY - this.overflowOffset.top < b.scrollSensitivity) this.scrollParent[0].scrollTop = c = this.scrollParent[0].scrollTop - b.scrollSpeed;
                    if (this.overflowOffset.left + this.scrollParent[0].offsetWidth - a.pageX < b.scrollSensitivity) this.scrollParent[0].scrollLeft = c = this.scrollParent[0].scrollLeft + b.scrollSpeed;
                    else if (a.pageX - this.overflowOffset.left < b.scrollSensitivity) this.scrollParent[0].scrollLeft = c = this.scrollParent[0].scrollLeft - b.scrollSpeed
                } else {
                    if (a.pageY - d(document).scrollTop() < b.scrollSensitivity) c = d(document).scrollTop(d(document).scrollTop() -
                            b.scrollSpeed);
                    else if (d(window).height() - (a.pageY - d(document).scrollTop()) < b.scrollSensitivity) c = d(document).scrollTop(d(document).scrollTop() + b.scrollSpeed);
                    if (a.pageX - d(document).scrollLeft() < b.scrollSensitivity) c = d(document).scrollLeft(d(document).scrollLeft() - b.scrollSpeed);
                    else if (d(window).width() - (a.pageX - d(document).scrollLeft()) < b.scrollSensitivity) c = d(document).scrollLeft(d(document).scrollLeft() + b.scrollSpeed)
                }
                c !== false && d.ui.ddmanager && !b.dropBehaviour && d.ui.ddmanager.prepareOffsets(this, a)
            }
            this.positionAbs = this._convertPositionTo("absolute");
            if (!this.options.axis || this.options.axis != "y") this.helper[0].style.left = this.position.left + "px";
            if (!this.options.axis || this.options.axis != "x") this.helper[0].style.top = this.position.top + "px";
            for (b = this.items.length - 1; b >= 0; b--) {
                c = this.items[b];
                var e = c.item[0],
                    f = this._intersectsWithPointer(c);
                if (f) if (e != this.currentItem[0] && this.placeholder[f == 1 ? "next" : "prev"]()[0] != e && !d.ui.contains(this.placeholder[0], e) && (this.options.type == "semi-dynamic" ? !d.ui.contains(this.element[0], e) : true)) {
                        this.direction = f == 1 ? "down" : "up";
                        if (this.options.tolerance == "pointer" || this._intersectsWithSides(c)) this._rearrange(a, c);
                        else break;
                        this._trigger("change", a, this._uiHash());
                        break
                    }
            }
            this._contactContainers(a);
            d.ui.ddmanager && d.ui.ddmanager.drag(this, a);
            this._trigger("sort", a, this._uiHash());
            this.lastPositionAbs = this.positionAbs;
            return false
        },
        _mouseStop: function (a, b) {
            if (a) {
                d.ui.ddmanager && !this.options.dropBehaviour && d.ui.ddmanager.drop(this, a);
                if (this.options.revert) {
                    var c = this;
                    b = c.placeholder.offset();
                    c.reverting = true;
                    d(this.helper).animate({
                        left: b.left - this.offset.parent.left - c.margins.left + (this.offsetParent[0] == document.body ? 0 : this.offsetParent[0].scrollLeft),
                        top: b.top - this.offset.parent.top - c.margins.top + (this.offsetParent[0] == document.body ? 0 : this.offsetParent[0].scrollTop)
                    }, parseInt(this.options.revert, 10) || 500, function () {
                        c._clear(a)
                    })
                } else this._clear(a, b);
                return false
            }
        },
        cancel: function () {
            var a = this;
            if (this.dragging) {
                this._mouseUp({
                    target: null
                });
                this.options.helper == "original" ? this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper") : this.currentItem.show();
                for (var b = this.containers.length - 1; b >= 0; b--) {
                    this.containers[b]._trigger("deactivate", null, a._uiHash(this));
                    if (this.containers[b].containerCache.over) {
                        this.containers[b]._trigger("out", null, a._uiHash(this));
                        this.containers[b].containerCache.over = 0
                    }
                }
            }
            if (this.placeholder) {
                this.placeholder[0].parentNode && this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
                this.options.helper != "original" && this.helper && this.helper[0].parentNode && this.helper.remove();
                d.extend(this, {
                    helper: null,
                    dragging: false,
                    reverting: false,
                    _noFinalSort: null
                });
                this.domPosition.prev ? d(this.domPosition.prev).after(this.currentItem) : d(this.domPosition.parent).prepend(this.currentItem)
            }
            return this
        },
        serialize: function (a) {
            var b = this._getItemsAsjQuery(a && a.connected),
                c = [];
            a = a || {};
            d(b).each(function () {
                var e = (d(a.item || this).attr(a.attribute || "id") || "").match(a.expression || /(.+)[-=_](.+)/);
                if (e) c.push((a.key || e[1] + "[]") + "=" + (a.key && a.expression ? e[1] : e[2]))
            });
            !c.length && a.key && c.push(a.key + "=");
            return c.join("&")
        },
        toArray: function (a) {
            var b = this._getItemsAsjQuery(a && a.connected),
                c = [];
            a = a || {};
            b.each(function () {
                c.push(d(a.item || this).attr(a.attribute || "id") || "")
            });
            return c
        },
        _intersectsWith: function (a) {
            var b = this.positionAbs.left,
                c = b + this.helperProportions.width,
                e = this.positionAbs.top,
                f = e + this.helperProportions.height,
                g = a.left,
                h = g + a.width,
                i = a.top,
                k = i + a.height,
                j = this.offset.click.top,
                l = this.offset.click.left;
            j = e + j > i && e + j < k && b + l > g && b + l < h;
            return this.options.tolerance == "pointer" || this.options.forcePointerForContainers || this.options.tolerance != "pointer" && this.helperProportions[this.floating ? "width" : "height"] > a[this.floating ? "width" : "height"] ? j : g < b + this.helperProportions.width / 2 && c - this.helperProportions.width / 2 < h && i < e + this.helperProportions.height / 2 && f - this.helperProportions.height / 2 < k
        },
        _intersectsWithPointer: function (a) {
            var b = d.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, a.top, a.height);
            a = d.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, a.left, a.width);
            b = b && a;
            a = this._getDragVerticalDirection();
            var c = this._getDragHorizontalDirection();
            if (!b) return false;
            return this.floating ? c && c == "right" || a == "down" ? 2 : 1 : a && (a == "down" ? 2 : 1)
        },
        _intersectsWithSides: function (a) {
            var b = d.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, a.top + a.height / 2, a.height);
            a = d.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, a.left + a.width / 2, a.width);
            var c = this._getDragVerticalDirection(),
                e = this._getDragHorizontalDirection();
            return this.floating && e ? e == "right" && a || e == "left" && !a : c && (c == "down" && b || c == "up" && !b)
        },
        _getDragVerticalDirection: function () {
            var a = this.positionAbs.top - this.lastPositionAbs.top;
            return a != 0 && (a > 0 ? "down" : "up")
        },
        _getDragHorizontalDirection: function () {
            var a = this.positionAbs.left - this.lastPositionAbs.left;
            return a != 0 && (a > 0 ? "right" : "left")
        },
        refresh: function (a) {
            this._refreshItems(a);
            this.refreshPositions();
            return this
        },
        _connectWith: function () {
            var a = this.options;
            return a.connectWith.constructor == String ? [a.connectWith] : a.connectWith
        },
        _getItemsAsjQuery: function (a) {
            var b = [],
                c = [],
                e = this._connectWith();
            if (e && a) for (a = e.length - 1; a >= 0; a--) for (var f = d(e[a]), g = f.length - 1; g >= 0; g--) {
                        var h = d.data(f[g], "sortable");
                        if (h && h != this && !h.options.disabled) c.push([d.isFunction(h.options.items) ? h.options.items.call(h.element) : d(h.options.items, h.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), h])
            }
            c.push([d.isFunction(this.options.items) ? this.options.items.call(this.element, null, {
                    options: this.options,
                    item: this.currentItem
                }) : d(this.options.items, this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"), this]);
            for (a = c.length - 1; a >= 0; a--) c[a][0].each(function () {
                    b.push(this)
                });
            return d(b)
        },
        _removeCurrentsFromItems: function () {
            for (var a = this.currentItem.find(":data(sortable-item)"), b = 0; b < this.items.length; b++) for (var c = 0; c < a.length; c++) a[c] == this.items[b].item[0] && this.items.splice(b, 1)
        },
        _refreshItems: function (a) {
            this.items = [];
            this.containers = [this];
            var b = this.items,
                c = [
                    [d.isFunction(this.options.items) ? this.options.items.call(this.element[0], a, {
                            item: this.currentItem
                        }) : d(this.options.items, this.element), this]
                ],
                e = this._connectWith();
            if (e) for (var f = e.length - 1; f >= 0; f--) for (var g = d(e[f]), h = g.length - 1; h >= 0; h--) {
                        var i = d.data(g[h], "sortable");
                        if (i && i != this && !i.options.disabled) {
                            c.push([d.isFunction(i.options.items) ? i.options.items.call(i.element[0], a, {
                                    item: this.currentItem
                                }) : d(i.options.items, i.element), i]);
                            this.containers.push(i)
                        }
            }
            for (f = c.length - 1; f >= 0; f--) {
                a = c[f][1];
                e = c[f][0];
                h = 0;
                for (g = e.length; h < g; h++) {
                    i = d(e[h]);
                    i.data("sortable-item", a);
                    b.push({
                        item: i,
                        instance: a,
                        width: 0,
                        height: 0,
                        left: 0,
                        top: 0
                    })
                }
            }
        },
        refreshPositions: function (a) {
            if (this.offsetParent && this.helper) this.offset.parent = this._getParentOffset();
            for (var b = this.items.length - 1; b >= 0; b--) {
                var c = this.items[b];
                if (!(c.instance != this.currentContainer && this.currentContainer && c.item[0] != this.currentItem[0])) {
                    var e = this.options.toleranceElement ? d(this.options.toleranceElement, c.item) : c.item;
                    if (!a) {
                        c.width = e.outerWidth();
                        c.height = e.outerHeight()
                    }
                    e = e.offset();
                    c.left = e.left;
                    c.top = e.top
                }
            }
            if (this.options.custom && this.options.custom.refreshContainers) this.options.custom.refreshContainers.call(this);
            else for (b = this.containers.length - 1; b >= 0; b--) {
                    e = this.containers[b].element.offset();
                    this.containers[b].containerCache.left = e.left;
                    this.containers[b].containerCache.top = e.top;
                    this.containers[b].containerCache.width = this.containers[b].element.outerWidth();
                    this.containers[b].containerCache.height = this.containers[b].element.outerHeight()
            }
            return this
        },
        _createPlaceholder: function (a) {
            var b = a || this,
                c = b.options;
            if (!c.placeholder || c.placeholder.constructor == String) {
                var e = c.placeholder;
                c.placeholder = {
                    element: function () {
                        var f = d(document.createElement(b.currentItem[0].nodeName)).addClass(e || b.currentItem[0].className + " ui-sortable-placeholder").removeClass("ui-sortable-helper")[0];
                        if (!e) f.style.visibility = "hidden";
                        return f
                    },
                    update: function (f, g) {
                        if (!(e && !c.forcePlaceholderSize)) {
                            g.height() || g.height(b.currentItem.innerHeight() - parseInt(b.currentItem.css("paddingTop") || 0, 10) - parseInt(b.currentItem.css("paddingBottom") || 0, 10));
                            g.width() || g.width(b.currentItem.innerWidth() - parseInt(b.currentItem.css("paddingLeft") || 0, 10) - parseInt(b.currentItem.css("paddingRight") || 0, 10))
                        }
                    }
                }
            }
            b.placeholder = d(c.placeholder.element.call(b.element, b.currentItem));
            b.currentItem.after(b.placeholder);
            c.placeholder.update(b, b.placeholder)
        },
        _contactContainers: function (a) {
            for (var b = null, c = null, e = this.containers.length - 1; e >= 0; e--) if (!d.ui.contains(this.currentItem[0], this.containers[e].element[0])) if (this._intersectsWith(this.containers[e].containerCache)) {
                        if (!(b && d.ui.contains(this.containers[e].element[0], b.element[0]))) {
                            b = this.containers[e];
                            c = e
                        }
                    } else if (this.containers[e].containerCache.over) {
                this.containers[e]._trigger("out", a, this._uiHash(this));
                this.containers[e].containerCache.over = 0
            }
            if (b) if (this.containers.length === 1) {
                    this.containers[c]._trigger("over", a, this._uiHash(this));
                    this.containers[c].containerCache.over = 1
                } else if (this.currentContainer != this.containers[c]) {
                b = 1E4;
                e = null;
                for (var f = this.positionAbs[this.containers[c].floating ? "left" : "top"], g = this.items.length - 1; g >= 0; g--) if (d.ui.contains(this.containers[c].element[0], this.items[g].item[0])) {
                        var h = this.items[g][this.containers[c].floating ? "left" : "top"];
                        if (Math.abs(h -
                            f) < b) {
                            b = Math.abs(h - f);
                            e = this.items[g]
                        }
                    }
                if (e || this.options.dropOnEmpty) {
                    this.currentContainer = this.containers[c];
                    e ? this._rearrange(a, e, null, true) : this._rearrange(a, null, this.containers[c].element, true);
                    this._trigger("change", a, this._uiHash());
                    this.containers[c]._trigger("change", a, this._uiHash(this));
                    this.options.placeholder.update(this.currentContainer, this.placeholder);
                    this.containers[c]._trigger("over", a, this._uiHash(this));
                    this.containers[c].containerCache.over = 1
                }
            }
        },
        _createHelper: function (a) {
            var b = this.options;
            a = d.isFunction(b.helper) ? d(b.helper.apply(this.element[0], [a, this.currentItem])) : b.helper == "clone" ? this.currentItem.clone() : this.currentItem;
            a.parents("body").length || d(b.appendTo != "parent" ? b.appendTo : this.currentItem[0].parentNode)[0].appendChild(a[0]);
            if (a[0] == this.currentItem[0]) this._storedCSS = {
                    width: this.currentItem[0].style.width,
                    height: this.currentItem[0].style.height,
                    position: this.currentItem.css("position"),
                    top: this.currentItem.css("top"),
                    left: this.currentItem.css("left")
            };
            if (a[0].style.width == "" || b.forceHelperSize) a.width(this.currentItem.width());
            if (a[0].style.height == "" || b.forceHelperSize) a.height(this.currentItem.height());
            return a
        },
        _adjustOffsetFromHelper: function (a) {
            if (typeof a == "string") a = a.split(" ");
            if (d.isArray(a)) a = {
                    left: +a[0],
                    top: +a[1] || 0
            };
            if ("left" in a) this.offset.click.left = a.left + this.margins.left;
            if ("right" in a) this.offset.click.left = this.helperProportions.width - a.right + this.margins.left;
            if ("top" in a) this.offset.click.top = a.top + this.margins.top;
            if ("bottom" in a) this.offset.click.top = this.helperProportions.height - a.bottom + this.margins.top
        },
        _getParentOffset: function () {
            this.offsetParent = this.helper.offsetParent();
            var a = this.offsetParent.offset();
            if (this.cssPosition == "absolute" && this.scrollParent[0] != document && d.ui.contains(this.scrollParent[0], this.offsetParent[0])) {
                a.left += this.scrollParent.scrollLeft();
                a.top += this.scrollParent.scrollTop()
            }
            if (this.offsetParent[0] == document.body || this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == "html" && d.browser.msie) a = {
                    top: 0,
                    left: 0
            };
            return {
                top: a.top + (parseInt(this.offsetParent.css("borderTopWidth"), 10) || 0),
                left: a.left + (parseInt(this.offsetParent.css("borderLeftWidth"), 10) || 0)
            }
        },
        _getRelativeOffset: function () {
            if (this.cssPosition == "relative") {
                var a = this.currentItem.position();
                return {
                    top: a.top - (parseInt(this.helper.css("top"), 10) || 0) + this.scrollParent.scrollTop(),
                    left: a.left - (parseInt(this.helper.css("left"), 10) || 0) + this.scrollParent.scrollLeft()
                }
            } else return {
                    top: 0,
                    left: 0
            }
        },
        _cacheMargins: function () {
            this.margins = {
                left: parseInt(this.currentItem.css("marginLeft"), 10) || 0,
                top: parseInt(this.currentItem.css("marginTop"), 10) || 0
            }
        },
        _cacheHelperProportions: function () {
            this.helperProportions = {
                width: this.helper.outerWidth(),
                height: this.helper.outerHeight()
            }
        },
        _setContainment: function () {
            var a = this.options;
            if (a.containment == "parent") a.containment = this.helper[0].parentNode;
            if (a.containment == "document" || a.containment == "window") this.containment = [0 - this.offset.relative.left - this.offset.parent.left, 0 - this.offset.relative.top - this.offset.parent.top, d(a.containment == "document" ? document : window).width() - this.helperProportions.width - this.margins.left, (d(a.containment == "document" ? document : window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top];
            if (!/^(document|window|parent)$/.test(a.containment)) {
                var b = d(a.containment)[0];
                a = d(a.containment).offset();
                var c = d(b).css("overflow") != "hidden";
                this.containment = [a.left + (parseInt(d(b).css("borderLeftWidth"), 10) || 0) + (parseInt(d(b).css("paddingLeft"), 10) || 0) - this.margins.left, a.top + (parseInt(d(b).css("borderTopWidth"), 10) || 0) + (parseInt(d(b).css("paddingTop"), 10) || 0) - this.margins.top, a.left + (c ? Math.max(b.scrollWidth, b.offsetWidth) : b.offsetWidth) - (parseInt(d(b).css("borderLeftWidth"), 10) || 0) - (parseInt(d(b).css("paddingRight"), 10) || 0) - this.helperProportions.width - this.margins.left, a.top + (c ? Math.max(b.scrollHeight, b.offsetHeight) : b.offsetHeight) - (parseInt(d(b).css("borderTopWidth"), 10) || 0) - (parseInt(d(b).css("paddingBottom"), 10) || 0) - this.helperProportions.height - this.margins.top]
            }
        },
        _convertPositionTo: function (a, b) {
            if (!b) b = this.position;
            a = a == "absolute" ? 1 : -1;
            var c = this.cssPosition == "absolute" && !(this.scrollParent[0] != document && d.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent,
                e = /(html|body)/i.test(c[0].tagName);
            return {
                top: b.top + this.offset.relative.top * a + this.offset.parent.top * a - (d.browser.safari && this.cssPosition == "fixed" ? 0 : (this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : e ? 0 : c.scrollTop()) * a),
                left: b.left + this.offset.relative.left * a + this.offset.parent.left * a - (d.browser.safari && this.cssPosition == "fixed" ? 0 : (this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : e ? 0 : c.scrollLeft()) * a)
            }
        },
        _generatePosition: function (a) {
            var b = this.options,
                c = this.cssPosition == "absolute" && !(this.scrollParent[0] != document && d.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent,
                e = /(html|body)/i.test(c[0].tagName);
            if (this.cssPosition == "relative" && !(this.scrollParent[0] != document && this.scrollParent[0] != this.offsetParent[0])) this.offset.relative = this._getRelativeOffset();
            var f = a.pageX,
                g = a.pageY;
            if (this.originalPosition) {
                if (this.containment) {
                    if (a.pageX - this.offset.click.left < this.containment[0]) f = this.containment[0] + this.offset.click.left;
                    if (a.pageY - this.offset.click.top < this.containment[1]) g = this.containment[1] + this.offset.click.top;
                    if (a.pageX - this.offset.click.left > this.containment[2]) f = this.containment[2] + this.offset.click.left;
                    if (a.pageY - this.offset.click.top > this.containment[3]) g = this.containment[3] + this.offset.click.top
                }
                if (b.grid) {
                    g = this.originalPageY + Math.round((g -
                        this.originalPageY) / b.grid[1]) * b.grid[1];
                    g = this.containment ? !(g - this.offset.click.top < this.containment[1] || g - this.offset.click.top > this.containment[3]) ? g : !(g - this.offset.click.top < this.containment[1]) ? g - b.grid[1] : g + b.grid[1] : g;
                    f = this.originalPageX + Math.round((f - this.originalPageX) / b.grid[0]) * b.grid[0];
                    f = this.containment ? !(f - this.offset.click.left < this.containment[0] || f - this.offset.click.left > this.containment[2]) ? f : !(f - this.offset.click.left < this.containment[0]) ? f - b.grid[0] : f + b.grid[0] : f
                }
            }
            return {
                top: g - this.offset.click.top - this.offset.relative.top - this.offset.parent.top + (d.browser.safari && this.cssPosition == "fixed" ? 0 : this.cssPosition == "fixed" ? -this.scrollParent.scrollTop() : e ? 0 : c.scrollTop()),
                left: f - this.offset.click.left - this.offset.relative.left - this.offset.parent.left + (d.browser.safari && this.cssPosition == "fixed" ? 0 : this.cssPosition == "fixed" ? -this.scrollParent.scrollLeft() : e ? 0 : c.scrollLeft())
            }
        },
        _rearrange: function (a, b, c, e) {
            c ? c[0].appendChild(this.placeholder[0]) : b.item[0].parentNode.insertBefore(this.placeholder[0], this.direction == "down" ? b.item[0] : b.item[0].nextSibling);
            this.counter = this.counter ? ++this.counter : 1;
            var f = this,
                g = this.counter;
            window.setTimeout(function () {
                g == f.counter && f.refreshPositions(!e)
            }, 0)
        },
        _clear: function (a, b) {
            this.reverting = false;
            var c = [];
            !this._noFinalSort && this.currentItem[0].parentNode && this.placeholder.before(this.currentItem);
            this._noFinalSort = null;
            if (this.helper[0] == this.currentItem[0]) {
                for (var e in this._storedCSS) if (this._storedCSS[e] == "auto" || this._storedCSS[e] == "static") this._storedCSS[e] = "";
                this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper")
            } else this.currentItem.show();
            this.fromOutside && !b && c.push(function (f) {
                this._trigger("receive", f, this._uiHash(this.fromOutside))
            });
            if ((this.fromOutside || this.domPosition.prev != this.currentItem.prev().not(".ui-sortable-helper")[0] || this.domPosition.parent != this.currentItem.parent()[0]) && !b) c.push(function (f) {
                    this._trigger("update", f, this._uiHash())
                });
            if (!d.ui.contains(this.element[0], this.currentItem[0])) {
                b || c.push(function (f) {
                    this._trigger("remove", f, this._uiHash())
                });
                for (e = this.containers.length - 1; e >= 0; e--) if (d.ui.contains(this.containers[e].element[0], this.currentItem[0]) && !b) {
                        c.push(function (f) {
                            return function (g) {
                                f._trigger("receive", g, this._uiHash(this))
                            }
                        }.call(this, this.containers[e]));
                        c.push(function (f) {
                            return function (g) {
                                f._trigger("update", g, this._uiHash(this))
                            }
                        }.call(this, this.containers[e]))
                    }
            }
            for (e = this.containers.length - 1; e >= 0; e--) {
                b || c.push(function (f) {
                    return function (g) {
                        f._trigger("deactivate", g, this._uiHash(this))
                    }
                }.call(this, this.containers[e]));
                if (this.containers[e].containerCache.over) {
                    c.push(function (f) {
                        return function (g) {
                            f._trigger("out", g, this._uiHash(this))
                        }
                    }.call(this, this.containers[e]));
                    this.containers[e].containerCache.over = 0
                }
            }
            this._storedCursor && d("body").css("cursor", this._storedCursor);
            this._storedOpacity && this.helper.css("opacity", this._storedOpacity);
            if (this._storedZIndex) this.helper.css("zIndex", this._storedZIndex == "auto" ? "" : this._storedZIndex);
            this.dragging = false;
            if (this.cancelHelperRemoval) {
                if (!b) {
                    this._trigger("beforeStop", a, this._uiHash());
                    for (e = 0; e < c.length; e++) c[e].call(this, a);
                    this._trigger("stop", a, this._uiHash())
                }
                return false
            }
            b || this._trigger("beforeStop", a, this._uiHash());
            this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
            this.helper[0] != this.currentItem[0] && this.helper.remove();
            this.helper = null;
            if (!b) {
                for (e = 0; e < c.length; e++) c[e].call(this, a);
                this._trigger("stop", a, this._uiHash())
            }
            this.fromOutside = false;
            return true
        },
        _trigger: function () {
            d.Widget.prototype._trigger.apply(this, arguments) === false && this.cancel()
        },
        _uiHash: function (a) {
            var b = a || this;
            return {
                helper: b.helper,
                placeholder: b.placeholder || d([]),
                position: b.position,
                originalPosition: b.originalPosition,
                offset: b.positionAbs,
                item: b.currentItem,
                sender: a ? a.element : null
            }
        }
    });
    d.extend(d.ui.sortable, {
        version: "1.8.12"
    })
})(jQuery);;
(function (d) {
    d.widget("ui.slider", d.ui.mouse, {
        widgetEventPrefix: "slide",
        options: {
            animate: false,
            distance: 0,
            max: 100,
            min: 0,
            orientation: "horizontal",
            range: false,
            step: 1,
            value: 0,
            values: null
        },
        _create: function () {
            var b = this,
                a = this.options;
            this._mouseSliding = this._keySliding = false;
            this._animateOff = true;
            this._handleIndex = null;
            this._detectOrientation();
            this._mouseInit();
            this.element.addClass("ui-slider ui-slider-" + this.orientation + " ui-widget ui-widget-content ui-corner-all");
            a.disabled && this.element.addClass("ui-slider-disabled ui-disabled");
            this.range = d([]);
            if (a.range) {
                if (a.range === true) {
                    this.range = d("<div></div>");
                    if (!a.values) a.values = [this._valueMin(), this._valueMin()];
                    if (a.values.length && a.values.length !== 2) a.values = [a.values[0], a.values[0]]
                } else this.range = d("<div></div>");
                this.range.appendTo(this.element).addClass("ui-slider-range");
                if (a.range === "min" || a.range === "max") this.range.addClass("ui-slider-range-" + a.range);
                this.range.addClass("ui-widget-header")
            }
            d(".ui-slider-handle", this.element).length === 0 && d("<a href='#'></a>").appendTo(this.element).addClass("ui-slider-handle");
            if (a.values && a.values.length) for (; d(".ui-slider-handle", this.element).length < a.values.length;) d("<a href='#'></a>").appendTo(this.element).addClass("ui-slider-handle");
            this.handles = d(".ui-slider-handle", this.element).addClass("ui-state-default ui-corner-all");
            this.handle = this.handles.eq(0);
            this.handles.add(this.range).filter("a").click(function (c) {
                c.preventDefault()
            }).hover(function () {
                a.disabled || d(this).addClass("ui-state-hover")
            }, function () {
                d(this).removeClass("ui-state-hover")
            }).focus(function () {
                if (a.disabled) d(this).blur();
                else {
                    d(".ui-slider .ui-state-focus").removeClass("ui-state-focus");
                    d(this).addClass("ui-state-focus")
                }
            }).blur(function () {
                d(this).removeClass("ui-state-focus")
            });
            this.handles.each(function (c) {
                d(this).data("index.ui-slider-handle", c)
            });
            this.handles.keydown(function (c) {
                var e = true,
                    f = d(this).data("index.ui-slider-handle"),
                    h, g, i;
                if (!b.options.disabled) {
                    switch (c.keyCode) {
                        case d.ui.keyCode.HOME:
                        case d.ui.keyCode.END:
                        case d.ui.keyCode.PAGE_UP:
                        case d.ui.keyCode.PAGE_DOWN:
                        case d.ui.keyCode.UP:
                        case d.ui.keyCode.RIGHT:
                        case d.ui.keyCode.DOWN:
                        case d.ui.keyCode.LEFT:
                            e = false;
                            if (!b._keySliding) {
                                b._keySliding = true;
                                d(this).addClass("ui-state-active");
                                h = b._start(c, f);
                                if (h === false) return
                            }
                            break
                    }
                    i = b.options.step;
                    h = b.options.values && b.options.values.length ? (g = b.values(f)) : (g = b.value());
                    switch (c.keyCode) {
                        case d.ui.keyCode.HOME:
                            g = b._valueMin();
                            break;
                        case d.ui.keyCode.END:
                            g = b._valueMax();
                            break;
                        case d.ui.keyCode.PAGE_UP:
                            g = b._trimAlignValue(h + (b._valueMax() - b._valueMin()) / 5);
                            break;
                        case d.ui.keyCode.PAGE_DOWN:
                            g = b._trimAlignValue(h - (b._valueMax() - b._valueMin()) / 5);
                            break;
                        case d.ui.keyCode.UP:
                        case d.ui.keyCode.RIGHT:
                            if (h === b._valueMax()) return;
                            g = b._trimAlignValue(h + i);
                            break;
                        case d.ui.keyCode.DOWN:
                        case d.ui.keyCode.LEFT:
                            if (h === b._valueMin()) return;
                            g = b._trimAlignValue(h - i);
                            break
                    }
                    b._slide(c, f, g);
                    return e
                }
            }).keyup(function (c) {
                var e = d(this).data("index.ui-slider-handle");
                if (b._keySliding) {
                    b._keySliding = false;
                    b._stop(c, e);
                    b._change(c, e);
                    d(this).removeClass("ui-state-active")
                }
            });
            this._refreshValue();
            this._animateOff = false
        },
        destroy: function () {
            this.handles.remove();
            this.range.remove();
            this.element.removeClass("ui-slider ui-slider-horizontal ui-slider-vertical ui-slider-disabled ui-widget ui-widget-content ui-corner-all").removeData("slider").unbind(".slider");
            this._mouseDestroy();
            return this
        },
        _mouseCapture: function (b) {
            var a = this.options,
                c, e, f, h, g;
            if (a.disabled) return false;
            this.elementSize = {
                width: this.element.outerWidth(),
                height: this.element.outerHeight()
            };
            this.elementOffset = this.element.offset();
            c = this._normValueFromMouse({
                x: b.pageX,
                y: b.pageY
            });
            e = this._valueMax() - this._valueMin() + 1;
            h = this;
            this.handles.each(function (i) {
                var j = Math.abs(c - h.values(i));
                if (e > j) {
                    e = j;
                    f = d(this);
                    g = i
                }
            });
            if (a.range === true && this.values(1) === a.min) {
                g += 1;
                f = d(this.handles[g])
            }
            if (this._start(b, g) === false) return false;
            this._mouseSliding = true;
            h._handleIndex = g;
            f.addClass("ui-state-active").focus();
            a = f.offset();
            this._clickOffset = !d(b.target).parents().andSelf().is(".ui-slider-handle") ? {
                left: 0,
                top: 0
            } : {
                left: b.pageX - a.left - f.width() / 2,
                top: b.pageY - a.top - f.height() / 2 - (parseInt(f.css("borderTopWidth"), 10) || 0) - (parseInt(f.css("borderBottomWidth"), 10) || 0) + (parseInt(f.css("marginTop"), 10) || 0)
            };
            this.handles.hasClass("ui-state-hover") || this._slide(b, g, c);
            return this._animateOff = true
        },
        _mouseStart: function () {
            return true
        },
        _mouseDrag: function (b) {
            var a = this._normValueFromMouse({
                x: b.pageX,
                y: b.pageY
            });
            this._slide(b, this._handleIndex, a);
            return false
        },
        _mouseStop: function (b) {
            this.handles.removeClass("ui-state-active");
            this._mouseSliding = false;
            this._stop(b, this._handleIndex);
            this._change(b, this._handleIndex);
            this._clickOffset = this._handleIndex = null;
            return this._animateOff = false
        },
        _detectOrientation: function () {
            this.orientation = this.options.orientation === "vertical" ? "vertical" : "horizontal"
        },
        _normValueFromMouse: function (b) {
            var a;
            if (this.orientation === "horizontal") {
                a = this.elementSize.width;
                b = b.x - this.elementOffset.left - (this._clickOffset ? this._clickOffset.left : 0)
            } else {
                a = this.elementSize.height;
                b = b.y - this.elementOffset.top - (this._clickOffset ? this._clickOffset.top : 0)
            }
            a = b / a;
            if (a > 1) a = 1;
            if (a < 0) a = 0;
            if (this.orientation === "vertical") a = 1 - a;
            b = this._valueMax() - this._valueMin();
            return this._trimAlignValue(this._valueMin() + a * b)
        },
        _start: function (b, a) {
            var c = {
                handle: this.handles[a],
                value: this.value()
            };
            if (this.options.values && this.options.values.length) {
                c.value = this.values(a);
                c.values = this.values()
            }
            return this._trigger("start", b, c)
        },
        _slide: function (b, a, c) {
            var e;
            if (this.options.values && this.options.values.length) {
                e = this.values(a ? 0 : 1);
                if (this.options.values.length === 2 && this.options.range === true && (a === 0 && c > e || a === 1 && c < e)) c = e;
                if (c !== this.values(a)) {
                    e = this.values();
                    e[a] = c;
                    b = this._trigger("slide", b, {
                        handle: this.handles[a],
                        value: c,
                        values: e
                    });
                    this.values(a ? 0 : 1);
                    b !== false && this.values(a, c, true)
                }
            } else if (c !== this.value()) {
                b = this._trigger("slide", b, {
                    handle: this.handles[a],
                    value: c
                });
                b !== false && this.value(c)
            }
        },
        _stop: function (b, a) {
            var c = {
                handle: this.handles[a],
                value: this.value()
            };
            if (this.options.values && this.options.values.length) {
                c.value = this.values(a);
                c.values = this.values()
            }
            this._trigger("stop", b, c)
        },
        _change: function (b, a) {
            if (!this._keySliding && !this._mouseSliding) {
                var c = {
                    handle: this.handles[a],
                    value: this.value()
                };
                if (this.options.values && this.options.values.length) {
                    c.value = this.values(a);
                    c.values = this.values()
                }
                this._trigger("change", b, c)
            }
        },
        value: function (b) {
            if (arguments.length) {
                this.options.value = this._trimAlignValue(b);
                this._refreshValue();
                this._change(null, 0)
            } else return this._value()
        },
        values: function (b, a) {
            var c, e, f;
            if (arguments.length > 1) {
                this.options.values[b] = this._trimAlignValue(a);
                this._refreshValue();
                this._change(null, b)
            } else if (arguments.length) if (d.isArray(arguments[0])) {
                    c = this.options.values;
                    e = arguments[0];
                    for (f = 0; f < c.length; f += 1) {
                        c[f] = this._trimAlignValue(e[f]);
                        this._change(null, f)
                    }
                    this._refreshValue()
                } else return this.options.values && this.options.values.length ? this._values(b) : this.value();
                else return this._values()
        },
        _setOption: function (b, a) {
            var c, e = 0;
            if (d.isArray(this.options.values)) e = this.options.values.length;
            d.Widget.prototype._setOption.apply(this, arguments);
            switch (b) {
                case "disabled":
                    if (a) {
                        this.handles.filter(".ui-state-focus").blur();
                        this.handles.removeClass("ui-state-hover");
                        this.handles.attr("disabled", "disabled");
                        this.element.addClass("ui-disabled")
                    } else {
                        this.handles.removeAttr("disabled");
                        this.element.removeClass("ui-disabled")
                    }
                    break;
                case "orientation":
                    this._detectOrientation();
                    this.element.removeClass("ui-slider-horizontal ui-slider-vertical").addClass("ui-slider-" + this.orientation);
                    this._refreshValue();
                    break;
                case "value":
                    this._animateOff = true;
                    this._refreshValue();
                    this._change(null, 0);
                    this._animateOff = false;
                    break;
                case "values":
                    this._animateOff = true;
                    this._refreshValue();
                    for (c = 0; c < e; c += 1) this._change(null, c);
                    this._animateOff = false;
                    break
            }
        },
        _value: function () {
            var b = this.options.value;
            return b = this._trimAlignValue(b)
        },
        _values: function (b) {
            var a, c;
            if (arguments.length) {
                a = this.options.values[b];
                return a = this._trimAlignValue(a)
            } else {
                a = this.options.values.slice();
                for (c = 0; c < a.length; c += 1) a[c] = this._trimAlignValue(a[c]);
                return a
            }
        },
        _trimAlignValue: function (b) {
            if (b <= this._valueMin()) return this._valueMin();
            if (b >= this._valueMax()) return this._valueMax();
            var a = this.options.step > 0 ? this.options.step : 1,
                c = (b - this._valueMin()) % a;
            alignValue = b - c;
            if (Math.abs(c) * 2 >= a) alignValue += c > 0 ? a : -a;
            return parseFloat(alignValue.toFixed(5))
        },
        _valueMin: function () {
            return this.options.min
        },
        _valueMax: function () {
            return this.options.max
        },
        _refreshValue: function () {
            var b = this.options.range,
                a = this.options,
                c = this,
                e = !this._animateOff ? a.animate : false,
                f, h = {}, g, i, j, l;
            if (this.options.values && this.options.values.length) this.handles.each(function (k) {
                    f = (c.values(k) - c._valueMin()) / (c._valueMax() - c._valueMin()) * 100;
                    h[c.orientation === "horizontal" ? "left" : "bottom"] = f + "%";
                    d(this).stop(1, 1)[e ? "animate" : "css"](h, a.animate);
                    if (c.options.range === true) if (c.orientation === "horizontal") {
                            if (k === 0) c.range.stop(1, 1)[e ? "animate" : "css"]({
                                    left: f + "%"
                                }, a.animate);
                            if (k === 1) c.range[e ? "animate" : "css"]({
                                    width: f - g + "%"
                                }, {
                                    queue: false,
                                    duration: a.animate
                                })
                        } else {
                            if (k === 0) c.range.stop(1, 1)[e ? "animate" : "css"]({
                                    bottom: f + "%"
                                }, a.animate);
                            if (k === 1) c.range[e ? "animate" : "css"]({
                                    height: f - g + "%"
                                }, {
                                    queue: false,
                                    duration: a.animate
                                })
                        }
                    g = f
                });
            else {
                i = this.value();
                j = this._valueMin();
                l = this._valueMax();
                f = l !== j ? (i - j) / (l - j) * 100 : 0;
                h[c.orientation === "horizontal" ? "left" : "bottom"] = f + "%";
                this.handle.stop(1, 1)[e ? "animate" : "css"](h, a.animate);
                if (b === "min" && this.orientation === "horizontal") this.range.stop(1, 1)[e ? "animate" : "css"]({
                        width: f + "%"
                    }, a.animate);
                if (b === "max" && this.orientation === "horizontal") this.range[e ? "animate" : "css"]({
                        width: 100 - f + "%"
                    }, {
                        queue: false,
                        duration: a.animate
                    });
                if (b === "min" && this.orientation === "vertical") this.range.stop(1, 1)[e ? "animate" : "css"]({
                        height: f + "%"
                    }, a.animate);
                if (b === "max" && this.orientation === "vertical") this.range[e ? "animate" : "css"]({
                        height: 100 - f + "%"
                    }, {
                        queue: false,
                        duration: a.animate
                    })
            }
        }
    });
    d.extend(d.ui.slider, {
        version: "1.8.12"
    })
})(jQuery);;
jQuery.effects || function (f, j) {
    function n(c) {
        var a;
        if (c && c.constructor == Array && c.length == 3) return c;
        if (a = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(c)) return [parseInt(a[1], 10), parseInt(a[2], 10), parseInt(a[3], 10)];
        if (a = /rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(c)) return [parseFloat(a[1]) * 2.55, parseFloat(a[2]) * 2.55, parseFloat(a[3]) * 2.55];
        if (a = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(c)) return [parseInt(a[1], 16), parseInt(a[2], 16), parseInt(a[3], 16)];
        if (a = /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(c)) return [parseInt(a[1] + a[1], 16), parseInt(a[2] + a[2], 16), parseInt(a[3] + a[3], 16)];
        if (/rgba\(0, 0, 0, 0\)/.exec(c)) return o.transparent;
        return o[f.trim(c).toLowerCase()]
    }
    function s(c, a) {
        var b;
        do {
            b = f.curCSS(c, a);
            if (b != "" && b != "transparent" || f.nodeName(c, "body")) break;
            a = "backgroundColor"
        } while (c = c.parentNode);
        return n(b)
    }
    function p() {
        var c = document.defaultView ? document.defaultView.getComputedStyle(this, null) : this.currentStyle,
            a = {}, b, d;
        if (c && c.length && c[0] && c[c[0]]) for (var e = c.length; e--;) {
                b = c[e];
                if (typeof c[b] == "string") {
                    d = b.replace(/\-(\w)/g, function (g, h) {
                        return h.toUpperCase()
                    });
                    a[d] = c[b]
                }
        } else for (b in c) if (typeof c[b] === "string") a[b] = c[b]; return a
    }
    function q(c) {
        var a, b;
        for (a in c) {
            b = c[a];
            if (b == null || f.isFunction(b) || a in t || /scrollbar/.test(a) || !/color/i.test(a) && isNaN(parseFloat(b))) delete c[a]
        }
        return c
    }
    function u(c, a) {
        var b = {
            _: 0
        }, d;
        for (d in a) if (c[d] != a[d]) b[d] = a[d];
        return b
    }
    function k(c, a, b, d) {
        if (typeof c == "object") {
            d = a;
            b = null;
            a = c;
            c = a.effect
        }
        if (f.isFunction(a)) {
            d = a;
            b = null;
            a = {}
        }
        if (typeof a == "number" || f.fx.speeds[a]) {
            d = b;
            b = a;
            a = {}
        }
        if (f.isFunction(b)) {
            d = b;
            b = null
        }
        a = a || {};
        b = b || a.duration;
        b = f.fx.off ? 0 : typeof b == "number" ? b : b in f.fx.speeds ? f.fx.speeds[b] : f.fx.speeds._default;
        d = d || a.complete;
        return [c, a, b, d]
    }
    function m(c) {
        if (!c || typeof c === "number" || f.fx.speeds[c]) return true;
        if (typeof c === "string" && !f.effects[c]) return true;
        return false
    }
    f.effects = {};
    f.each(["backgroundColor", "borderBottomColor", "borderLeftColor", "borderRightColor", "borderTopColor", "borderColor", "color", "outlineColor"], function (c, a) {
        f.fx.step[a] = function (b) {
            if (!b.colorInit) {
                b.start = s(b.elem, a);
                b.end = n(b.end);
                b.colorInit = true
            }
            b.elem.style[a] = "rgb(" + Math.max(Math.min(parseInt(b.pos * (b.end[0] - b.start[0]) + b.start[0], 10), 255), 0) + "," + Math.max(Math.min(parseInt(b.pos * (b.end[1] - b.start[1]) + b.start[1], 10), 255), 0) + "," + Math.max(Math.min(parseInt(b.pos * (b.end[2] - b.start[2]) + b.start[2], 10), 255), 0) + ")"
        }
    });
    var o = {
        aqua: [0, 255, 255],
        azure: [240, 255, 255],
        beige: [245, 245, 220],
        black: [0, 0, 0],
        blue: [0, 0, 255],
        brown: [165, 42, 42],
        cyan: [0, 255, 255],
        darkblue: [0, 0, 139],
        darkcyan: [0, 139, 139],
        darkgrey: [169, 169, 169],
        darkgreen: [0, 100, 0],
        darkkhaki: [189, 183, 107],
        darkmagenta: [139, 0, 139],
        darkolivegreen: [85, 107, 47],
        darkorange: [255, 140, 0],
        darkorchid: [153, 50, 204],
        darkred: [139, 0, 0],
        darksalmon: [233, 150, 122],
        darkviolet: [148, 0, 211],
        fuchsia: [255, 0, 255],
        gold: [255, 215, 0],
        green: [0, 128, 0],
        indigo: [75, 0, 130],
        khaki: [240, 230, 140],
        lightblue: [173, 216, 230],
        lightcyan: [224, 255, 255],
        lightgreen: [144, 238, 144],
        lightgrey: [211, 211, 211],
        lightpink: [255, 182, 193],
        lightyellow: [255, 255, 224],
        lime: [0, 255, 0],
        magenta: [255, 0, 255],
        maroon: [128, 0, 0],
        navy: [0, 0, 128],
        olive: [128, 128, 0],
        orange: [255, 165, 0],
        pink: [255, 192, 203],
        purple: [128, 0, 128],
        violet: [128, 0, 128],
        red: [255, 0, 0],
        silver: [192, 192, 192],
        white: [255, 255, 255],
        yellow: [255, 255, 0],
        transparent: [255, 255, 255]
    }, r = ["add", "remove", "toggle"],
        t = {
            border: 1,
            borderBottom: 1,
            borderColor: 1,
            borderLeft: 1,
            borderRight: 1,
            borderTop: 1,
            borderWidth: 1,
            margin: 1,
            padding: 1
        };
    f.effects.animateClass = function (c, a, b, d) {
        if (f.isFunction(b)) {
            d = b;
            b = null
        }
        return this.queue("fx", function () {
            var e = f(this),
                g = e.attr("style") || " ",
                h = q(p.call(this)),
                l, v = e.attr("className");
            f.each(r, function (w, i) {
                c[i] && e[i + "Class"](c[i])
            });
            l = q(p.call(this));
            e.attr("className", v);
            e.animate(u(h, l), a, b, function () {
                f.each(r, function (w, i) {
                    c[i] && e[i + "Class"](c[i])
                });
                if (typeof e.attr("style") == "object") {
                    e.attr("style").cssText = "";
                    e.attr("style").cssText = g
                } else e.attr("style", g);
                d && d.apply(this, arguments)
            });
            h = f.queue(this);
            l = h.splice(h.length - 1, 1)[0];
            h.splice(1, 0, l);
            f.dequeue(this)
        })
    };
    f.fn.extend({
        _addClass: f.fn.addClass,
        addClass: function (c, a, b, d) {
            return a ? f.effects.animateClass.apply(this, [{
                    add: c
                },
                a, b, d
            ]) : this._addClass(c)
        },
        _removeClass: f.fn.removeClass,
        removeClass: function (c, a, b, d) {
            return a ? f.effects.animateClass.apply(this, [{
                    remove: c
                },
                a, b, d
            ]) : this._removeClass(c)
        },
        _toggleClass: f.fn.toggleClass,
        toggleClass: function (c, a, b, d, e) {
            return typeof a == "boolean" || a === j ? b ? f.effects.animateClass.apply(this, [a ? {
                    add: c
                } : {
                    remove: c
                },
                b, d, e
            ]) : this._toggleClass(c, a) : f.effects.animateClass.apply(this, [{
                    toggle: c
                },
                a, b, d
            ])
        },
        switchClass: function (c, a, b, d, e) {
            return f.effects.animateClass.apply(this, [{
                    add: a,
                    remove: c
                },
                b, d, e
            ])
        }
    });
    f.extend(f.effects, {
        version: "1.8.12",
        save: function (c, a) {
            for (var b = 0; b < a.length; b++) a[b] !== null && c.data("ec.storage." + a[b], c[0].style[a[b]])
        },
        restore: function (c, a) {
            for (var b = 0; b < a.length; b++) a[b] !== null && c.css(a[b], c.data("ec.storage." + a[b]))
        },
        setMode: function (c, a) {
            if (a == "toggle") a = c.is(":hidden") ? "show" : "hide";
            return a
        },
        getBaseline: function (c, a) {
            var b;
            switch (c[0]) {
                case "top":
                    b = 0;
                    break;
                case "middle":
                    b = 0.5;
                    break;
                case "bottom":
                    b = 1;
                    break;
                default:
                    b = c[0] / a.height
            }
            switch (c[1]) {
                case "left":
                    c = 0;
                    break;
                case "center":
                    c = 0.5;
                    break;
                case "right":
                    c = 1;
                    break;
                default:
                    c = c[1] / a.width
            }
            return {
                x: c,
                y: b
            }
        },
        createWrapper: function (c) {
            if (c.parent().is(".ui-effects-wrapper")) return c.parent();
            var a = {
                width: c.outerWidth(true),
                height: c.outerHeight(true),
                "float": c.css("float")
            }, b = f("<div></div>").addClass("ui-effects-wrapper").css({
                    fontSize: "100%",
                    background: "transparent",
                    border: "none",
                    margin: 0,
                    padding: 0
                });
            c.wrap(b);
            b = c.parent();
            if (c.css("position") == "static") {
                b.css({
                    position: "relative"
                });
                c.css({
                    position: "relative"
                })
            } else {
                f.extend(a, {
                    position: c.css("position"),
                    zIndex: c.css("z-index")
                });
                f.each(["top", "left", "bottom", "right"], function (d, e) {
                    a[e] = c.css(e);
                    if (isNaN(parseInt(a[e], 10))) a[e] = "auto"
                });
                c.css({
                    position: "relative",
                    top: 0,
                    left: 0,
                    right: "auto",
                    bottom: "auto"
                })
            }
            return b.css(a).show()
        },
        removeWrapper: function (c) {
            if (c.parent().is(".ui-effects-wrapper")) return c.parent().replaceWith(c);
            return c
        },
        setTransition: function (c, a, b, d) {
            d = d || {};
            f.each(a, function (e, g) {
                unit = c.cssUnit(g);
                if (unit[0] > 0) d[g] = unit[0] * b + unit[1]
            });
            return d
        }
    });
    f.fn.extend({
        effect: function (c) {
            var a = k.apply(this, arguments),
                b = {
                    options: a[1],
                    duration: a[2],
                    callback: a[3]
                };
            a = b.options.mode;
            var d = f.effects[c];
            if (f.fx.off || !d) return a ? this[a](b.duration, b.callback) : this.each(function () {
                    b.callback && b.callback.call(this)
                });
            return d.call(this, b)
        },
        _show: f.fn.show,
        show: function (c) {
            if (m(c)) return this._show.apply(this, arguments);
            else {
                var a = k.apply(this, arguments);
                a[1].mode = "show";
                return this.effect.apply(this, a)
            }
        },
        _hide: f.fn.hide,
        hide: function (c) {
            if (m(c)) return this._hide.apply(this, arguments);
            else {
                var a = k.apply(this, arguments);
                a[1].mode = "hide";
                return this.effect.apply(this, a)
            }
        },
        __toggle: f.fn.toggle,
        toggle: function (c) {
            if (m(c) || typeof c === "boolean" || f.isFunction(c)) return this.__toggle.apply(this, arguments);
            else {
                var a = k.apply(this, arguments);
                a[1].mode = "toggle";
                return this.effect.apply(this, a)
            }
        },
        cssUnit: function (c) {
            var a = this.css(c),
                b = [];
            f.each(["em", "px", "%", "pt"], function (d, e) {
                if (a.indexOf(e) > 0) b = [parseFloat(a), e]
            });
            return b
        }
    });
    f.easing.jswing = f.easing.swing;
    f.extend(f.easing, {
        def: "easeOutQuad",
        swing: function (c, a, b, d, e) {
            return f.easing[f.easing.def](c, a, b, d, e)
        },
        easeInQuad: function (c, a, b, d, e) {
            return d * (a /= e) * a + b
        },
        easeOutQuad: function (c, a, b, d, e) {
            return -d * (a /= e) * (a - 2) + b
        },
        easeInOutQuad: function (c, a, b, d, e) {
            if ((a /= e / 2) < 1) return d / 2 * a * a + b;
            return -d / 2 * (--a * (a - 2) - 1) + b
        },
        easeInCubic: function (c, a, b, d, e) {
            return d * (a /= e) * a * a + b
        },
        easeOutCubic: function (c, a, b, d, e) {
            return d * ((a = a / e - 1) * a * a + 1) + b
        },
        easeInOutCubic: function (c, a, b, d, e) {
            if ((a /= e / 2) < 1) return d / 2 * a * a * a + b;
            return d / 2 * ((a -= 2) * a * a + 2) + b
        },
        easeInQuart: function (c, a, b, d, e) {
            return d * (a /= e) * a * a * a + b
        },
        easeOutQuart: function (c, a, b, d, e) {
            return -d * ((a = a / e - 1) * a * a * a - 1) + b
        },
        easeInOutQuart: function (c, a, b, d, e) {
            if ((a /= e / 2) < 1) return d / 2 * a * a * a * a + b;
            return -d / 2 * ((a -= 2) * a * a * a - 2) + b
        },
        easeInQuint: function (c, a, b, d, e) {
            return d * (a /= e) * a * a * a * a + b
        },
        easeOutQuint: function (c, a, b, d, e) {
            return d * ((a = a / e - 1) * a * a * a * a + 1) + b
        },
        easeInOutQuint: function (c, a, b, d, e) {
            if ((a /= e / 2) < 1) return d / 2 * a * a * a * a * a + b;
            return d / 2 * ((a -= 2) * a * a * a * a + 2) + b
        },
        easeInSine: function (c, a, b, d, e) {
            return -d * Math.cos(a / e * (Math.PI / 2)) + d + b
        },
        easeOutSine: function (c, a, b, d, e) {
            return d * Math.sin(a / e * (Math.PI / 2)) + b
        },
        easeInOutSine: function (c, a, b, d, e) {
            return -d / 2 * (Math.cos(Math.PI * a / e) - 1) + b
        },
        easeInExpo: function (c, a, b, d, e) {
            return a == 0 ? b : d * Math.pow(2, 10 * (a / e - 1)) + b
        },
        easeOutExpo: function (c, a, b, d, e) {
            return a == e ? b + d : d * (-Math.pow(2, -10 * a / e) + 1) + b
        },
        easeInOutExpo: function (c, a, b, d, e) {
            if (a == 0) return b;
            if (a == e) return b + d;
            if ((a /= e / 2) < 1) return d / 2 * Math.pow(2, 10 * (a - 1)) + b;
            return d / 2 * (-Math.pow(2, -10 * --a) + 2) + b
        },
        easeInCirc: function (c, a, b, d, e) {
            return -d * (Math.sqrt(1 - (a /= e) * a) - 1) + b
        },
        easeOutCirc: function (c, a, b, d, e) {
            return d * Math.sqrt(1 - (a = a / e - 1) * a) + b
        },
        easeInOutCirc: function (c, a, b, d, e) {
            if ((a /= e / 2) < 1) return -d / 2 * (Math.sqrt(1 - a * a) - 1) + b;
            return d / 2 * (Math.sqrt(1 - (a -= 2) * a) + 1) + b
        },
        easeInElastic: function (c, a, b, d, e) {
            c = 1.70158;
            var g = 0,
                h = d;
            if (a == 0) return b;
            if ((a /= e) == 1) return b + d;
            g || (g = e * 0.3);
            if (h < Math.abs(d)) {
                h = d;
                c = g / 4
            } else c = g / (2 * Math.PI) * Math.asin(d / h);
            return -(h * Math.pow(2, 10 * (a -= 1)) * Math.sin((a * e - c) * 2 * Math.PI / g)) + b
        },
        easeOutElastic: function (c, a, b, d, e) {
            c = 1.70158;
            var g = 0,
                h = d;
            if (a == 0) return b;
            if ((a /= e) == 1) return b + d;
            g || (g = e * 0.3);
            if (h < Math.abs(d)) {
                h = d;
                c = g / 4
            } else c = g / (2 * Math.PI) * Math.asin(d / h);
            return h * Math.pow(2, -10 * a) * Math.sin((a * e - c) * 2 * Math.PI / g) + d + b
        },
        easeInOutElastic: function (c, a, b, d, e) {
            c = 1.70158;
            var g = 0,
                h = d;
            if (a == 0) return b;
            if ((a /= e / 2) == 2) return b + d;
            g || (g = e * 0.3 * 1.5);
            if (h < Math.abs(d)) {
                h = d;
                c = g / 4
            } else c = g / (2 * Math.PI) * Math.asin(d / h); if (a < 1) return -0.5 * h * Math.pow(2, 10 * (a -= 1)) * Math.sin((a * e - c) * 2 * Math.PI / g) + b;
            return h * Math.pow(2, -10 * (a -= 1)) * Math.sin((a * e - c) * 2 * Math.PI / g) * 0.5 + d + b
        },
        easeInBack: function (c, a, b, d, e, g) {
            if (g == j) g = 1.70158;
            return d * (a /= e) * a * ((g + 1) * a - g) + b
        },
        easeOutBack: function (c, a, b, d, e, g) {
            if (g == j) g = 1.70158;
            return d * ((a = a / e - 1) * a * ((g + 1) * a + g) + 1) + b
        },
        easeInOutBack: function (c, a, b, d, e, g) {
            if (g == j) g = 1.70158;
            if ((a /= e / 2) < 1) return d / 2 * a * a * (((g *= 1.525) + 1) * a - g) + b;
            return d / 2 * ((a -= 2) * a * (((g *= 1.525) + 1) * a + g) + 2) + b
        },
        easeInBounce: function (c, a, b, d, e) {
            return d - f.easing.easeOutBounce(c, e - a, 0, d, e) + b
        },
        easeOutBounce: function (c, a, b, d, e) {
            return (a /= e) < 1 / 2.75 ? d * 7.5625 * a * a + b : a < 2 / 2.75 ? d * (7.5625 * (a -= 1.5 / 2.75) * a + 0.75) + b : a < 2.5 / 2.75 ? d * (7.5625 * (a -= 2.25 / 2.75) * a + 0.9375) + b : d * (7.5625 * (a -= 2.625 / 2.75) * a + 0.984375) + b
        },
        easeInOutBounce: function (c, a, b, d, e) {
            if (a < e / 2) return f.easing.easeInBounce(c, a * 2, 0, d, e) * 0.5 + b;
            return f.easing.easeOutBounce(c, a * 2 - e, 0, d, e) * 0.5 + d * 0.5 + b
        }
    })
}(jQuery);;
(function (b) {
    b.effects.blind = function (c) {
        return this.queue(function () {
            var a = b(this),
                g = ["position", "top", "bottom", "left", "right"],
                f = b.effects.setMode(a, c.options.mode || "hide"),
                d = c.options.direction || "vertical";
            b.effects.save(a, g);
            a.show();
            var e = b.effects.createWrapper(a).css({
                overflow: "hidden"
            }),
                h = d == "vertical" ? "height" : "width";
            d = d == "vertical" ? e.height() : e.width();
            f == "show" && e.css(h, 0);
            var i = {};
            i[h] = f == "show" ? d : 0;
            e.animate(i, c.duration, c.options.easing, function () {
                f == "hide" && a.hide();
                b.effects.restore(a, g);
                b.effects.removeWrapper(a);
                c.callback && c.callback.apply(a[0], arguments);
                a.dequeue()
            })
        })
    }
})(jQuery);;
(function (e) {
    e.effects.bounce = function (b) {
        return this.queue(function () {
            var a = e(this),
                l = ["position", "top", "bottom", "left", "right"],
                h = e.effects.setMode(a, b.options.mode || "effect"),
                d = b.options.direction || "up",
                c = b.options.distance || 20,
                m = b.options.times || 5,
                i = b.duration || 250;
            /show|hide/.test(h) && l.push("opacity");
            e.effects.save(a, l);
            a.show();
            e.effects.createWrapper(a);
            var f = d == "up" || d == "down" ? "top" : "left";
            d = d == "up" || d == "left" ? "pos" : "neg";
            c = b.options.distance || (f == "top" ? a.outerHeight({
                margin: true
            }) / 3 : a.outerWidth({
                margin: true
            }) / 3);
            if (h == "show") a.css("opacity", 0).css(f, d == "pos" ? -c : c);
            if (h == "hide") c /= m * 2;
            h != "hide" && m--;
            if (h == "show") {
                var g = {
                    opacity: 1
                };
                g[f] = (d == "pos" ? "+=" : "-=") + c;
                a.animate(g, i / 2, b.options.easing);
                c /= 2;
                m--
            }
            for (g = 0; g < m; g++) {
                var j = {}, k = {};
                j[f] = (d == "pos" ? "-=" : "+=") + c;
                k[f] = (d == "pos" ? "+=" : "-=") + c;
                a.animate(j, i / 2, b.options.easing).animate(k, i / 2, b.options.easing);
                c = h == "hide" ? c * 2 : c / 2
            }
            if (h == "hide") {
                g = {
                    opacity: 0
                };
                g[f] = (d == "pos" ? "-=" : "+=") + c;
                a.animate(g, i / 2, b.options.easing, function () {
                    a.hide();
                    e.effects.restore(a, l);
                    e.effects.removeWrapper(a);
                    b.callback && b.callback.apply(this, arguments)
                })
            } else {
                j = {};
                k = {};
                j[f] = (d == "pos" ? "-=" : "+=") + c;
                k[f] = (d == "pos" ? "+=" : "-=") + c;
                a.animate(j, i / 2, b.options.easing).animate(k, i / 2, b.options.easing, function () {
                    e.effects.restore(a, l);
                    e.effects.removeWrapper(a);
                    b.callback && b.callback.apply(this, arguments)
                })
            }
            a.queue("fx", function () {
                a.dequeue()
            });
            a.dequeue()
        })
    }
})(jQuery);;
(function (b) {
    b.effects.clip = function (e) {
        return this.queue(function () {
            var a = b(this),
                i = ["position", "top", "bottom", "left", "right", "height", "width"],
                f = b.effects.setMode(a, e.options.mode || "hide"),
                c = e.options.direction || "vertical";
            b.effects.save(a, i);
            a.show();
            var d = b.effects.createWrapper(a).css({
                overflow: "hidden"
            });
            d = a[0].tagName == "IMG" ? d : a;
            var g = {
                size: c == "vertical" ? "height" : "width",
                position: c == "vertical" ? "top" : "left"
            };
            c = c == "vertical" ? d.height() : d.width();
            if (f == "show") {
                d.css(g.size, 0);
                d.css(g.position, c / 2)
            }
            var h = {};
            h[g.size] = f == "show" ? c : 0;
            h[g.position] = f == "show" ? 0 : c / 2;
            d.animate(h, {
                queue: false,
                duration: e.duration,
                easing: e.options.easing,
                complete: function () {
                    f == "hide" && a.hide();
                    b.effects.restore(a, i);
                    b.effects.removeWrapper(a);
                    e.callback && e.callback.apply(a[0], arguments);
                    a.dequeue()
                }
            })
        })
    }
})(jQuery);;
(function (c) {
    c.effects.drop = function (d) {
        return this.queue(function () {
            var a = c(this),
                h = ["position", "top", "bottom", "left", "right", "opacity"],
                e = c.effects.setMode(a, d.options.mode || "hide"),
                b = d.options.direction || "left";
            c.effects.save(a, h);
            a.show();
            c.effects.createWrapper(a);
            var f = b == "up" || b == "down" ? "top" : "left";
            b = b == "up" || b == "left" ? "pos" : "neg";
            var g = d.options.distance || (f == "top" ? a.outerHeight({
                margin: true
            }) / 2 : a.outerWidth({
                margin: true
            }) / 2);
            if (e == "show") a.css("opacity", 0).css(f, b == "pos" ? -g : g);
            var i = {
                opacity: e == "show" ? 1 : 0
            };
            i[f] = (e == "show" ? b == "pos" ? "+=" : "-=" : b == "pos" ? "-=" : "+=") + g;
            a.animate(i, {
                queue: false,
                duration: d.duration,
                easing: d.options.easing,
                complete: function () {
                    e == "hide" && a.hide();
                    c.effects.restore(a, h);
                    c.effects.removeWrapper(a);
                    d.callback && d.callback.apply(this, arguments);
                    a.dequeue()
                }
            })
        })
    }
})(jQuery);;
(function (j) {
    j.effects.explode = function (a) {
        return this.queue(function () {
            var c = a.options.pieces ? Math.round(Math.sqrt(a.options.pieces)) : 3,
                d = a.options.pieces ? Math.round(Math.sqrt(a.options.pieces)) : 3;
            a.options.mode = a.options.mode == "toggle" ? j(this).is(":visible") ? "hide" : "show" : a.options.mode;
            var b = j(this).show().css("visibility", "hidden"),
                g = b.offset();
            g.top -= parseInt(b.css("marginTop"), 10) || 0;
            g.left -= parseInt(b.css("marginLeft"), 10) || 0;
            for (var h = b.outerWidth(true), i = b.outerHeight(true), e = 0; e < c; e++) for (var f = 0; f < d; f++) b.clone().appendTo("body").wrap("<div></div>").css({
                        position: "absolute",
                        visibility: "visible",
                        left: -f * (h / d),
                        top: -e * (i / c)
                    }).parent().addClass("ui-effects-explode").css({
                        position: "absolute",
                        overflow: "hidden",
                        width: h / d,
                        height: i / c,
                        left: g.left + f * (h / d) + (a.options.mode == "show" ? (f - Math.floor(d / 2)) * (h / d) : 0),
                        top: g.top + e * (i / c) + (a.options.mode == "show" ? (e - Math.floor(c / 2)) * (i / c) : 0),
                        opacity: a.options.mode == "show" ? 0 : 1
                    }).animate({
                        left: g.left + f * (h / d) + (a.options.mode == "show" ? 0 : (f - Math.floor(d / 2)) * (h / d)),
                        top: g.top + e * (i / c) + (a.options.mode == "show" ? 0 : (e - Math.floor(c / 2)) * (i / c)),
                        opacity: a.options.mode == "show" ? 1 : 0
                    }, a.duration || 500);
            setTimeout(function () {
                a.options.mode == "show" ? b.css({
                    visibility: "visible"
                }) : b.css({
                    visibility: "visible"
                }).hide();
                a.callback && a.callback.apply(b[0]);
                b.dequeue();
                j("div.ui-effects-explode").remove()
            }, a.duration || 500)
        })
    }
})(jQuery);;
(function (b) {
    b.effects.fade = function (a) {
        return this.queue(function () {
            var c = b(this),
                d = b.effects.setMode(c, a.options.mode || "hide");
            c.animate({
                opacity: d
            }, {
                queue: false,
                duration: a.duration,
                easing: a.options.easing,
                complete: function () {
                    a.callback && a.callback.apply(this, arguments);
                    c.dequeue()
                }
            })
        })
    }
})(jQuery);;
(function (c) {
    c.effects.fold = function (a) {
        return this.queue(function () {
            var b = c(this),
                j = ["position", "top", "bottom", "left", "right"],
                d = c.effects.setMode(b, a.options.mode || "hide"),
                g = a.options.size || 15,
                h = !! a.options.horizFirst,
                k = a.duration ? a.duration / 2 : c.fx.speeds._default / 2;
            c.effects.save(b, j);
            b.show();
            var e = c.effects.createWrapper(b).css({
                overflow: "hidden"
            }),
                f = d == "show" != h,
                l = f ? ["width", "height"] : ["height", "width"];
            f = f ? [e.width(), e.height()] : [e.height(), e.width()];
            var i = /([0-9]+)%/.exec(g);
            if (i) g = parseInt(i[1], 10) / 100 * f[d == "hide" ? 0 : 1];
            if (d == "show") e.css(h ? {
                    height: 0,
                    width: g
                } : {
                    height: g,
                    width: 0
                });
            h = {};
            i = {};
            h[l[0]] = d == "show" ? f[0] : g;
            i[l[1]] = d == "show" ? f[1] : 0;
            e.animate(h, k, a.options.easing).animate(i, k, a.options.easing, function () {
                d == "hide" && b.hide();
                c.effects.restore(b, j);
                c.effects.removeWrapper(b);
                a.callback && a.callback.apply(b[0], arguments);
                b.dequeue()
            })
        })
    }
})(jQuery);;
(function (b) {
    b.effects.highlight = function (c) {
        return this.queue(function () {
            var a = b(this),
                e = ["backgroundImage", "backgroundColor", "opacity"],
                d = b.effects.setMode(a, c.options.mode || "show"),
                f = {
                    backgroundColor: a.css("backgroundColor")
                };
            if (d == "hide") f.opacity = 0;
            b.effects.save(a, e);
            a.show().css({
                backgroundImage: "none",
                backgroundColor: c.options.color || "#ffff99"
            }).animate(f, {
                queue: false,
                duration: c.duration,
                easing: c.options.easing,
                complete: function () {
                    d == "hide" && a.hide();
                    b.effects.restore(a, e);
                    d == "show" && !b.support.opacity && this.style.removeAttribute("filter");
                    c.callback && c.callback.apply(this, arguments);
                    a.dequeue()
                }
            })
        })
    }
})(jQuery);;
(function (d) {
    d.effects.pulsate = function (a) {
        return this.queue(function () {
            var b = d(this),
                c = d.effects.setMode(b, a.options.mode || "show");
            times = (a.options.times || 5) * 2 - 1;
            duration = a.duration ? a.duration / 2 : d.fx.speeds._default / 2;
            isVisible = b.is(":visible");
            animateTo = 0;
            if (!isVisible) {
                b.css("opacity", 0).show();
                animateTo = 1
            }
            if (c == "hide" && isVisible || c == "show" && !isVisible) times--;
            for (c = 0; c < times; c++) {
                b.animate({
                    opacity: animateTo
                }, duration, a.options.easing);
                animateTo = (animateTo + 1) % 2
            }
            b.animate({
                opacity: animateTo
            }, duration, a.options.easing, function () {
                animateTo == 0 && b.hide();
                a.callback && a.callback.apply(this, arguments)
            });
            b.queue("fx", function () {
                b.dequeue()
            }).dequeue()
        })
    }
})(jQuery);;
(function (c) {
    c.effects.puff = function (b) {
        return this.queue(function () {
            var a = c(this),
                e = c.effects.setMode(a, b.options.mode || "hide"),
                g = parseInt(b.options.percent, 10) || 150,
                h = g / 100,
                i = {
                    height: a.height(),
                    width: a.width()
                };
            c.extend(b.options, {
                fade: true,
                mode: e,
                percent: e == "hide" ? g : 100,
                from: e == "hide" ? i : {
                    height: i.height * h,
                    width: i.width * h
                }
            });
            a.effect("scale", b.options, b.duration, b.callback);
            a.dequeue()
        })
    };
    c.effects.scale = function (b) {
        return this.queue(function () {
            var a = c(this),
                e = c.extend(true, {}, b.options),
                g = c.effects.setMode(a, b.options.mode || "effect"),
                h = parseInt(b.options.percent, 10) || (parseInt(b.options.percent, 10) == 0 ? 0 : g == "hide" ? 0 : 100),
                i = b.options.direction || "both",
                f = b.options.origin;
            if (g != "effect") {
                e.origin = f || ["middle", "center"];
                e.restore = true
            }
            f = {
                height: a.height(),
                width: a.width()
            };
            a.from = b.options.from || (g == "show" ? {
                height: 0,
                width: 0
            } : f);
            h = {
                y: i != "horizontal" ? h / 100 : 1,
                x: i != "vertical" ? h / 100 : 1
            };
            a.to = {
                height: f.height * h.y,
                width: f.width * h.x
            };
            if (b.options.fade) {
                if (g == "show") {
                    a.from.opacity = 0;
                    a.to.opacity = 1
                }
                if (g == "hide") {
                    a.from.opacity = 1;
                    a.to.opacity = 0
                }
            }
            e.from = a.from;
            e.to = a.to;
            e.mode = g;
            a.effect("size", e, b.duration, b.callback);
            a.dequeue()
        })
    };
    c.effects.size = function (b) {
        return this.queue(function () {
            var a = c(this),
                e = ["position", "top", "bottom", "left", "right", "width", "height", "overflow", "opacity"],
                g = ["position", "top", "bottom", "left", "right", "overflow", "opacity"],
                h = ["width", "height", "overflow"],
                i = ["fontSize"],
                f = ["borderTopWidth", "borderBottomWidth", "paddingTop", "paddingBottom"],
                k = ["borderLeftWidth", "borderRightWidth", "paddingLeft", "paddingRight"],
                p = c.effects.setMode(a, b.options.mode || "effect"),
                n = b.options.restore || false,
                m = b.options.scale || "both",
                l = b.options.origin,
                j = {
                    height: a.height(),
                    width: a.width()
                };
            a.from = b.options.from || j;
            a.to = b.options.to || j;
            if (l) {
                l = c.effects.getBaseline(l, j);
                a.from.top = (j.height - a.from.height) * l.y;
                a.from.left = (j.width - a.from.width) * l.x;
                a.to.top = (j.height - a.to.height) * l.y;
                a.to.left = (j.width - a.to.width) * l.x
            }
            var d = {
                from: {
                    y: a.from.height / j.height,
                    x: a.from.width / j.width
                },
                to: {
                    y: a.to.height / j.height,
                    x: a.to.width / j.width
                }
            };
            if (m == "box" || m == "both") {
                if (d.from.y != d.to.y) {
                    e = e.concat(f);
                    a.from = c.effects.setTransition(a, f, d.from.y, a.from);
                    a.to = c.effects.setTransition(a, f, d.to.y, a.to)
                }
                if (d.from.x != d.to.x) {
                    e = e.concat(k);
                    a.from = c.effects.setTransition(a, k, d.from.x, a.from);
                    a.to = c.effects.setTransition(a, k, d.to.x, a.to)
                }
            }
            if (m == "content" || m == "both") if (d.from.y != d.to.y) {
                    e = e.concat(i);
                    a.from = c.effects.setTransition(a, i, d.from.y, a.from);
                    a.to = c.effects.setTransition(a, i, d.to.y, a.to)
                }
            c.effects.save(a, n ? e : g);
            a.show();
            c.effects.createWrapper(a);
            a.css("overflow", "hidden").css(a.from);
            if (m == "content" || m == "both") {
                f = f.concat(["marginTop", "marginBottom"]).concat(i);
                k = k.concat(["marginLeft", "marginRight"]);
                h = e.concat(f).concat(k);
                a.find("*[width]").each(function () {
                    child = c(this);
                    n && c.effects.save(child, h);
                    var o = {
                        height: child.height(),
                        width: child.width()
                    };
                    child.from = {
                        height: o.height * d.from.y,
                        width: o.width * d.from.x
                    };
                    child.to = {
                        height: o.height * d.to.y,
                        width: o.width * d.to.x
                    };
                    if (d.from.y != d.to.y) {
                        child.from = c.effects.setTransition(child, f, d.from.y, child.from);
                        child.to = c.effects.setTransition(child, f, d.to.y, child.to)
                    }
                    if (d.from.x != d.to.x) {
                        child.from = c.effects.setTransition(child, k, d.from.x, child.from);
                        child.to = c.effects.setTransition(child, k, d.to.x, child.to)
                    }
                    child.css(child.from);
                    child.animate(child.to, b.duration, b.options.easing, function () {
                        n && c.effects.restore(child, h)
                    })
                })
            }
            a.animate(a.to, {
                queue: false,
                duration: b.duration,
                easing: b.options.easing,
                complete: function () {
                    a.to.opacity === 0 && a.css("opacity", a.from.opacity);
                    p == "hide" && a.hide();
                    c.effects.restore(a, n ? e : g);
                    c.effects.removeWrapper(a);
                    b.callback && b.callback.apply(this, arguments);
                    a.dequeue()
                }
            })
        })
    }
})(jQuery);;
(function (d) {
    d.effects.shake = function (a) {
        return this.queue(function () {
            var b = d(this),
                j = ["position", "top", "bottom", "left", "right"];
            d.effects.setMode(b, a.options.mode || "effect");
            var c = a.options.direction || "left",
                e = a.options.distance || 20,
                l = a.options.times || 3,
                f = a.duration || a.options.duration || 140;
            d.effects.save(b, j);
            b.show();
            d.effects.createWrapper(b);
            var g = c == "up" || c == "down" ? "top" : "left",
                h = c == "up" || c == "left" ? "pos" : "neg";
            c = {};
            var i = {}, k = {};
            c[g] = (h == "pos" ? "-=" : "+=") + e;
            i[g] = (h == "pos" ? "+=" : "-=") + e * 2;
            k[g] = (h == "pos" ? "-=" : "+=") + e * 2;
            b.animate(c, f, a.options.easing);
            for (e = 1; e < l; e++) b.animate(i, f, a.options.easing).animate(k, f, a.options.easing);
            b.animate(i, f, a.options.easing).animate(c, f / 2, a.options.easing, function () {
                d.effects.restore(b, j);
                d.effects.removeWrapper(b);
                a.callback && a.callback.apply(this, arguments)
            });
            b.queue("fx", function () {
                b.dequeue()
            });
            b.dequeue()
        })
    }
})(jQuery);;
(function (c) {
    c.effects.slide = function (d) {
        return this.queue(function () {
            var a = c(this),
                h = ["position", "top", "bottom", "left", "right"],
                f = c.effects.setMode(a, d.options.mode || "show"),
                b = d.options.direction || "left";
            c.effects.save(a, h);
            a.show();
            c.effects.createWrapper(a).css({
                overflow: "hidden"
            });
            var g = b == "up" || b == "down" ? "top" : "left";
            b = b == "up" || b == "left" ? "pos" : "neg";
            var e = d.options.distance || (g == "top" ? a.outerHeight({
                margin: true
            }) : a.outerWidth({
                margin: true
            }));
            if (f == "show") a.css(g, b == "pos" ? isNaN(e) ? "-" + e : -e : e);
            var i = {};
            i[g] = (f == "show" ? b == "pos" ? "+=" : "-=" : b == "pos" ? "-=" : "+=") + e;
            a.animate(i, {
                queue: false,
                duration: d.duration,
                easing: d.options.easing,
                complete: function () {
                    f == "hide" && a.hide();
                    c.effects.restore(a, h);
                    c.effects.removeWrapper(a);
                    d.callback && d.callback.apply(this, arguments);
                    a.dequeue()
                }
            })
        })
    }
})(jQuery);;
(function (e) {
    e.effects.transfer = function (a) {
        return this.queue(function () {
            var b = e(this),
                c = e(a.options.to),
                d = c.offset();
            c = {
                top: d.top,
                left: d.left,
                height: c.innerHeight(),
                width: c.innerWidth()
            };
            d = b.offset();
            var f = e('<div class="ui-effects-transfer"></div>').appendTo(document.body).addClass(a.options.className).css({
                top: d.top,
                left: d.left,
                height: b.innerHeight(),
                width: b.innerWidth(),
                position: "absolute"
            }).animate(c, a.duration, a.options.easing, function () {
                f.remove();
                a.callback && a.callback.apply(b[0], arguments);
                b.dequeue()
            })
        })
    }
})(jQuery);;;
var slots = [];
var carousel = new function () {
        var carouselTypes = {
            carouselType7: {
                cssClass: "carouselType7",
                name: "carouselType7",
                itemSmallHeight: 118,
                itemSmallWidth: 118,
                focusItemHeight: 164,
                focusItemWidth: 164,
                visibleItems: 7,
                defaultFocusItem: 4,
                smallItemBorderWidth: 1,
                focusItemBorderWidth: 3,
                focusItemTextBox: 170,
                focusItemFontSize: 13,
                smallItemfontSize: 11,
                scrollToItemCount: 1,
                smallItemBorderColor: '#ccc',
                focusItem: function (itemCount) {
                    return getFocusItem(itemCount, carouselTypes.carouselType7);
                },
                getSliderProperties: function (itemCount, activeItem, visibleItems, slot, sizes) {
                    return getSliderProperties(itemCount, activeItem, visibleItems, slot, sizes);
                },
                setLargeItemBox: function (focusItemBorderWidth, focusItemWidth, focusItemHeight, focusItemTextBox, focusItemFontSize) {
                    setLargeItemBox(focusItemBorderWidth, focusItemWidth, focusItemHeight, focusItemTextBox, focusItemFontSize);
                },
                animateItemsOnStart: function (slotValues, slot, uiValue, sizes) {
                    animateItemsOnStart(slotValues, slot, uiValue, sizes);
                },
                animateFocusItemSize: function (sizes) {
                    animateFocusItemSize(sizes, 100, carouselTypes.carouselType7);
                },
                animateAllBorders: function (sizes, slot) {
                    animateAllBorders(sizes, slot);
                },
                animateTextLarge: function (sizes, speed) {
                    animateTextLarge(sizes, speed);
                },
                sliderAction: function (nextStep, stepValue, position, uiValue, itemCount, sizes, activeItem, slot) {
                    return sliderAction(nextStep, stepValue, position, uiValue, itemCount, sizes, activeItem, slot);
                },
                moveItems: function (sizes, speed) {
                    moveItemsOneStep(sizes, speed);
                },
                slideRightByClick: function (slot, sizes) {
                    slideGrowingRight(slot, sizes);
                },
                createLi: function (itemCount, slot, visibleItems) {
                    createLi(itemCount, slot, visibleItems);
                }
            },
            carouselType3: {
                name: "carouselType3",
                itemSmallHeight: 118,
                itemSmallWidth: 118,
                focusItemHeight: 164,
                focusItemWidth: 164,
                visibleItems: 3,
                defaultFocusItem: 2,
                smallItemBorderWidth: 1,
                focusItemBorderWidth: 3,
                focusItemTextBox: 170,
                focusItemFontSize: 13,
                smallItemfontSize: 11,
                scrollToItemCount: 1,
                smallItemBorderColor: '#ccc',
                focusItem: function (itemCount) {
                    return getFocusItem(itemCount, carouselTypes.carouselType3);
                },
                getSliderProperties: function (itemCount, activeItem, visibleItems, slot, sizes) {
                    return getSliderProperties(itemCount, activeItem, visibleItems, slot, sizes);
                },
                setLargeItemBox: function (focusItemBorderWidth, focusItemWidth, focusItemHeight, focusItemTextBox, focusItemFontSize) {
                    setLargeItemBox(focusItemBorderWidth, focusItemWidth, focusItemHeight, focusItemTextBox, focusItemFontSize);
                },
                animateItemsOnStart: function (slotValues, slot, uiValue, sizes) {
                    animateItemsOnStart(slotValues, slot, uiValue, sizes);
                },
                animateFocusItemSize: function (sizes) {
                    animateFocusItemSize(sizes, 100, carouselTypes.carouselType3);
                },
                animateAllBorders: function (sizes, slot) {
                    animateAllBorders(sizes, slot);
                },
                animateTextLarge: function (sizes, speed) {
                    animateTextLarge(sizes, speed);
                },
                sliderAction: function (nextStep, stepValue, position, uiValue, itemCount, sizes, activeItem, slot) {
                    return sliderAction(nextStep, stepValue, position, uiValue, itemCount, sizes, activeItem, slot);
                },
                moveItems: function (sizes, speed) {
                    moveItemsOneStep(sizes, speed);
                },
                slideRightByClick: function (slot, sizes) {
                    slideGrowingRight(slot, sizes);
                },
                createLi: function (itemCount, slot, visibleItems) {
                    createLi(itemCount, slot, visibleItems);
                }
            },
            carouselType5: {
                name: "carouselType5",
                itemSmallHeight: 118,
                itemSmallWidth: 118,
                focusItemHeight: 164,
                focusItemWidth: 164,
                visibleItems: 5,
                defaultFocusItem: 1,
                smallItemBorderWidth: 1,
                focusItemBorderWidth: 3,
                focusItemTextBox: 0,
                scrollToItemCount: 5,
                smallItemBorderColor: '#ccc',
                focusItem: function (itemCount) {
                    return this.defaultFocusItem;
                },
                getSliderProperties: function (itemCount, activeItem, visibleItems, slot, sizes) {
                    return getConstantSliderProperties(sizes, activeItem, itemCount, visibleItems);
                },
                slideRightByClick: function (slot, sizes) {
                    slideConstantRight(slot, carouselTypes.carouselType5, sizes);
                },
                createLi: function (itemCount, slot, visibleItems) {
                    createLi(itemCount, slot, visibleItems);
                }
            }
        };

        function resolveCarouselType(carouselTypeName) {
            return carouselTypes[carouselTypeName];
        }

        function slideCarousel(slot, type) {
            if (typeof colorValueModul !== "undefined") {
                if (colorValueModul.indexOf("#") == -1) {
                    colorValueModul = '#' + colorValueModul;
                }
            } else {
                colorValueModul = '#f00';
            }
            var mySlot = {};
            mySlot.animationStyle;
            mySlot.activeItem;
            mySlot.oldActiveItem;
            mySlot.type = type;
            mySlot.oldSliderValue;
            mySlot.sliderValue;
            mySlot.sliderMax;
            mySlot.itemCount = getItems(slot).length;
            mySlot.visibleItems = type.visibleItems;
            mySlot.isCreated;
            slots[slot] = mySlot;
            var itemCount = slots[slot].itemCount;
            if (typeof type.focusItem !== "undefined") {
                var focusItem = type.focusItem(itemCount);
            } else {
                var focusItem = 1;
            }
            slots[slot].activeItem = focusItem;
            slots[slot].oldActiveItem = focusItem;
            createCarousel(slot);
            slots[slot].isCreated = true;
            var ul = $(slot + " .js_ottoCarousel");
            var animationStyle = $(slot + " ul").attr("class");
            if (animationStyle) {
                if (animationStyle.indexOf("js_growingItems") != -1) {
                    slots[slot].animationStyle = "growing";
                } else {
                    slots[slot].animationStyle = "small";
                }
            } else {
                slots[slot].animationStyle = "small";
            }
            if (slots[slot].itemCount == 1) {
                sizes = new getItemSizes(slot, slots[slot].activeItem, (slots[slot].activeItem));
            } else {
                sizes = new getItemSizes(slot, slots[slot].activeItem, (slots[slot].activeItem + 1));
            }
            var sliderProperties = type.getSliderProperties(itemCount, slots[slot].activeItem, slots[slot].visibleItems, slot, sizes);
            if (typeof type.setLargeItemBox !== "undefined") {
                type.setLargeItemBox(type.focusItemBorderWidth, type.focusItemWidth, type.focusItemHeight, type.focusItemTextBox, type.focusItemFontSize);
            }
            var sliderMax = sliderProperties.sliderMax;
            var sliderMin = sliderProperties.sliderMin;
            slots[slot].sliderMax = sliderMax;
            var sliderValue = sliderProperties.sliderValue;
            slots[slot].sliderValue = sliderValue;
            var allIlItems = getAllIlItems(slot);
            var ulWidth = ((allIlItems * sizes.smallItemSumWidth) + 300);
            sizes.ul.css('width', ulWidth);
            var position = 0;
            var nextStep = 0;
            if (slots[slot].itemCount > type.scrollToItemCount) {
                $(slot + ' .slider').slider({
                    step: 1,
                    min: sliderMin,
                    max: sliderMax,
                    value: slots[slot].sliderValue,
                    animate: true,
                    start: function (event, ui) {
                        if (slots[slot].itemCount > 1) {
                            if (typeof type.animateItemsOnStart !== "undefined") {
                                type.animateItemsOnStart(slots[slot], slot, ui.value, sizes);
                            }
                            slots[slot].oldSliderValue = ui.value;
                        }
                    },
                    stop: function (event, ui) {
                        if (event.keyCode == 37 && slots[slot]['activeItem'] > 1) {
                            $(slot + " .js_lastStep").click();
                        } else if (event.keyCode == 39 && slots[slot]['activeItem'] < slots[slot]['itemCount']) {
                            $(slot + " .js_nextStep").click();
                        } else {
                            if (slots[slot].itemCount > 1) {
                                sizes = new getItemSizes(slot, slots[slot].oldActiveItem, itemToHighlight);
                                var itemToHighlight = Math.round(ui.value / sizes.smallItemSumWidth);
                                slots[slot].activeItem = itemToHighlight;
                                var sliderInfo = new getSliderInfo(slot, sizes.smallItemSumWidth, slots[slot].activeItem);
                                $(sliderInfo.slider).slider("option", "value", (sliderInfo.sliderPosition - sliderInfo.sliderDiff));
                                if (slots[slot].oldSliderValue != ui.value) {
                                    sizes.ul.animate({
                                        'left': '+=' + sliderInfo.sliderDiff
                                    }, 200);
                                }
                                if (typeof type.animateFocusItemSize !== "undefined") {
                                    type.animateFocusItemSize(sizes);
                                }
                                if (typeof type.animateAllBorders !== "undefined") {
                                    type.animateAllBorders(sizes, slot);
                                }
                                if (typeof type.animateTextLarge !== "undefined") {
                                    type.animateTextLarge(sizes, 100);
                                }
                                setActiveClass(sizes);
                                slots[slot].activeItem = itemToHighlight;
                                slots[slot].oldActiveItem = slots[slot].activeItem;
                                slots[slot].oldSliderValue = ui.value;
                            }
                        }
                    },
                    change: function (event, ui) {},
                    slide: function (event, ui) {
                        if (slots[slot].itemCount > 1) {
                            var stepValue = Math.round(ui.value / sizes.smallItemSumWidth);
                            var marginMove = (slots[slot].sliderValue - ui.value);
                            ul.css('left', marginMove);
                            if (typeof type.sliderAction !== "undefined") {
                                var sliderActionVars = type.sliderAction(nextStep, stepValue, position, ui.value, slots[slot].itemCount, sizes, slots[slot].activeItem, slot);
                                nextStep = sliderActionVars.nextStep;
                                position = sliderActionVars.position;
                                slots[slot].activeItem = sliderActionVars.activeItem;
                            }
                        }
                    }
                });
            } else {
                $(slot + " .js_sliderBox").hide();
            }
            $(slot + " .js_lastStep").click(function () {
                activeItem = slots[slot].activeItem;
                if (typeof pageType !== 'undefined' && pageType[0] === 'articleview') {
                    var slotName = $(this).parents('.carouselBox').attr('id');
                }
                if (activeItem != null && activeItem != '1') {
                    sizes = new getItemSizes(slot, activeItem, (activeItem - 1));
                    var sliderInfo = new getSliderInfo(slot, sizes.smallItemSumWidth, activeItem);
                    if (typeof type.moveItems !== "undefined") {
                        type.moveItems(sizes, 400);
                    }
                    restMove = sizes.smallItemSumWidth + sliderInfo.sliderDiff;
                    sizes.ul.animate({
                        left: '+=' + restMove
                    }, 400);
                    $(sliderInfo.slider).slider("option", "value", (sliderInfo.sliderPosition - restMove));
                    sizes.thisItemBox.removeClass("itemActive");
                    sizes.nextItemBox.addClass("itemActive");
                    slots[slot].oldActiveItem = activeItem - 1;
                    slots[slot].activeItem = activeItem - 1;
                }
            });
            $(slot + " .js_nextStep").click(function () {
                var slot = $(this).parents('.carouselBox').attr('id');
                slot = "#" + slot;
                activeItem = slots[slot].activeItem;
                if (typeof pageType !== 'undefined' && pageType[0] === 'articleview') {
                    var slotName = $(this).parents('.carouselBox').attr('id');
                }
                slots[slot].type.slideRightByClick(slot, sizes);
            });
        }

        function slideRight(position, slot) {
            sizes = new getItemSizes(slot, slots[slot].oldActiveItem, position);
            if (slots[slot].animationStyle == "growing") {
                moveItemsOneStep(sizes, 100);
            } else {
                moveItems(sizes, 100);
            }
            slots[slot].oldActiveItem = position;
            slots[slot].activeItem = position;
        }

        function slideLeft(position, slot) {
            sizes = new getItemSizes(slot, slots[slot].oldActiveItem, position);
            if (slots[slot].animationStyle == "growing") {
                moveItemsOneStep(sizes, 100);
            } else {
                moveItems(sizes, 100);
            }
            slots[slot].oldActiveItem = position;
            slots[slot].activeItem = position;
        }

        function slideConstantRight(slot, type, sizes) {
            if (slots[slot].itemCount > type.visibleItems) {
                if (activeItem <= slots[slot].itemCount && activeItem < (slots[slot].itemCount - (type.visibleItems - 1))) {
                    if (activeItem != null) {
                        sliderInfo = new getSliderInfo(slot, sizes.smallItemSumWidth, slots[slot].activeItem);
                        sizes = new getItemSizes(slot, activeItem, (activeItem + 1));
                        restMove = sizes.smallItemSumWidth;
                        sizes.ul.animate({
                            left: '-=' + restMove
                        }, 400);
                        $(sliderInfo.slider).slider("option", "value", (sliderInfo.sliderPosition + restMove));
                        sizes.thisItemBox.removeClass("itemActive");
                        sizes.nextItemBox.addClass("itemActive");
                        slots[slot].oldActiveItem = activeItem + 1;
                        slots[slot].activeItem = activeItem + 1;
                    }
                }
            }
        }

        function slideGrowingRight(slot, sizes) {
            activeItem = slots[slot].activeItem;
            if (activeItem < slots[slot].itemCount) {
                if (activeItem != null) {
                    sliderInfo = new getSliderInfo(slot, sizes.smallItemSumWidth, activeItem);
                    sizes = new getItemSizes(slot, activeItem, (activeItem + 1));
                    if (activeItem == 1) {
                        restMove = sizes.smallItemSumWidth;
                    } else {
                        restMove = sizes.smallItemSumWidth;
                    }
                    moveItemsOneStep(sizes, 400);
                    sizes.ul.animate({
                        left: '-=' + restMove
                    }, 400);
                    if (activeItem == (slots[slot].itemCount - 1)) {
                        $(sliderInfo.slider).slider("option", "value", slots[slot].sliderMax);
                    } else {
                        $(sliderInfo.slider).slider("option", "value", (sliderInfo.sliderPosition + restMove));
                    }
                    sizes.thisItemBox.removeClass("itemActive");
                    sizes.nextItemBox.addClass("itemActive");
                    slots[slot].oldActiveItem = activeItem + 1;
                    slots[slot].activeItem = activeItem + 1;
                }
            }
        }

        function moveItemsOneStep(sizes, speed) {
            var focusItemWidth = slots[sizes.slot].type.focusItemWidth;
            var focusItemHeight = slots[sizes.slot].type.focusItemHeight;
            var smallItemBorderColor = slots[sizes.slot].type.smallItemBorderColor;
            var smallItemBorderWidth = slots[sizes.slot].type.smallItemBorderWidth;
            var focusItemBorderWidth = slots[sizes.slot].type.focusItemBorderWidth;
            var textBoxSize = slots[sizes.slot].type.focusItemTextBox;
            var fontSizeFocusItem = slots[sizes.slot].type.focusItemFontSize;
            var fontSizeNoneFocusItem = slots[sizes.slot].type.smallItemfontSize;
            setPictureSize(sizes.thisItemPicture, speed, sizes.smallItemWidth + "px");
            setPictureSize(sizes.nextItemPicture, speed, focusItemWidth + "px");
            sizes.thisItemBox.animate({
                height: sizes.smallItemHeight + "px",
                width: sizes.smallItemWidth + "px",
                borderWidth: smallItemBorderWidth + "px",
                borderTopColor: smallItemBorderColor,
                borderRightColor: smallItemBorderColor,
                borderBottomColor: smallItemBorderColor,
                borderLeftColor: smallItemBorderColor
            }, speed);
            sizes.thisTextBox.animate({
                width: sizes.smallItemWidth + "px",
                fontSize: fontSizeNoneFocusItem + "px"
            }, speed);
            sizes.nextItemBox.animate({
                height: focusItemHeight + "px",
                width: focusItemWidth + "px",
                borderWidth: focusItemBorderWidth + "px",
                borderTopColor: colorValueModul,
                borderRightColor: colorValueModul,
                borderBottomColor: colorValueModul,
                borderLeftColor: colorValueModul
            }, speed);
            sizes.nextTextBox.animate({
                width: textBoxSize + 'px',
                fontSize: fontSizeFocusItem + "px"
            }, speed);
            sizes.thisItemBox.removeClass("itemActive");
            sizes.nextItemBox.addClass("itemActive");
        }

        function moveItems(sizes, speed) {
            var smallItemBorderColor = slots[sizes.slot].type.smallItemBorderColor;
            var smallItemBorderWidth = slots[sizes.slot].type.smallItemBorderWidth;
            var focusItemBorderWidth = slots[sizes.slot].type.focusItemBorderWidth;
            var fontSizeFocusItem = slots[sizes.slot].type.focusItemFontSize;
            sizes.thisItemBox.css({
                borderWidth: smallItemBorderWidth + "px",
                borderTopColor: smallItemBorderColor,
                borderRightColor: smallItemBorderColor,
                borderBottomColor: smallItemBorderColor,
                borderLeftColor: smallItemBorderColor
            });
            sizes.nextItemBox.css({
                borderWidth: focusItemBorderWidth + "px",
                borderTopColor: colorValueModul,
                borderRightColor: colorValueModul,
                borderBottomColor: colorValueModul,
                borderLeftColor: colorValueModul
            });
        }

        function getItemSizes(slot, activeItem, nextActiveItem) {
            var activeSlot = getActiveItem(slot);
            this.slot = slot;
            this.ul = $(slot + " .js_ottoCarousel");
            if (activeSlot != 1 || getItems(slot).length === 1) {
                this.firstItem = (slot + " .js_ottoCarousel > .js_listItem_1 .js_itemBox");
            } else {
                this.firstItem = (slot + " .js_ottoCarousel > .js_listItem_2 .js_itemBox");
            }
            var $firstItem = $(this.firstItem);
            this.smallItemWidth = parseInt($firstItem.css('width'));
            this.smallItemHeight = parseInt($firstItem.css('height'));
            this.smallItemMargin = parseInt($firstItem.css('marginRight'));
            this.smallItemSumWidth = parseInt(this.smallItemWidth + 2 + this.smallItemMargin);
            this.thisItems = $(slot + " .js_listItem_" + activeItem);
            this.nextItem = $(slot + " .js_listItem_" + nextActiveItem);
            this.thisItemText = this.thisItems.find(".js_itemText");
            this.nextItemText = this.nextItem.find(".js_itemText");
            this.thisTextBox = this.thisItems.children(".itemText");
            this.nextTextBox = this.nextItem.children(".itemText");
            this.thisItemBox = this.thisItems.children(".js_itemBox");
            this.nextItemBox = this.nextItem.children(".js_itemBox");
            this.thisItemPicture = this.thisItemBox.children().children("a").children("img");
            this.nextItemPicture = this.nextItemBox.children().children("a").children("img");
        }

        function getSliderInfo(slot, smallItemSumWidth, activeItem) {
            this.slider = slot + " div .slider";
            this.sliderWidth = this.sliderPosition = parseInt($(this.slider).slider('value'));
            this.sliderPositionShouldBe = (smallItemSumWidth * activeItem);
            this.sliderDiff = (this.sliderPosition - this.sliderPositionShouldBe);
        }

        function getFocusItem(itemCount, type) {
            if (itemCount < type.visibleItems) {
                var focusItem = Math.round(itemCount / 2);
            } else {
                var focusItem = Math.ceil(type.visibleItems / 2);
            }
            return focusItem;
        }

        function getSliderProperties(itemCount, activeItem, visibleItems, slot, sizes) {
            var sliderMax = parseInt(itemCount * sizes.smallItemSumWidth);
            var sliderValue = activeItem * sizes.smallItemSumWidth;
            var sliderMin = sizes.smallItemSumWidth;
            var largeItemWidth = parseInt($(".itemActive", slot).width());
            if (itemCount < visibleItems) {
                var slotItemCount = itemCount;
                if (slotItemCount % 2 != 0) {
                    slotItemCount = slotItemCount + 1;
                }
            }
            return {
                sliderMax: sliderMax,
                sliderValue: sliderValue,
                sliderMin: sliderMin
            };
        }

        function getConstantSliderProperties(sizes, activeItem, itemCount, visibleItems) {
            var sliderMin = sizes.smallItemSumWidth;
            var sliderValue = activeItem * sizes.smallItemSumWidth;
            setPictureSize(sizes.thisItemPicture, 100, sizes.smallItemWidth + "px");
            if (parseInt(itemCount) > visibleItems) {
                var sliderMax = parseInt(((itemCount) - (visibleItems - 1)) * sizes.smallItemSumWidth);
            } else {
                sliderMax = sliderMin;
            }
            return {
                sliderMax: sliderMax,
                sliderValue: sliderValue,
                sliderMin: sliderMin
            };
        }

        function setLargeItemBox(focusItemBorderWidth, focusItemWidth, focusItemHeight, focusItemTextBox, focusItemFontSize) {
            sizes.thisItemBox.css({
                'border': focusItemBorderWidth + 'px solid ' + colorValueModul,
                'width': focusItemWidth + 'px',
                'height': focusItemHeight + 'px'
            });
            sizes.thisTextBox.css({
                'width': focusItemTextBox + 'px',
                'font-size': focusItemFontSize + 'px'
            });
        }

        function animateItemsOnStart(slotValues, slot, uiValue, sizes) {
            if (slotValues.animationStyle == "growing") {
                slotValues.oldActiveItem = slotValues.activeItem
                slotValues.activeItem = Math.round(uiValue / sizes.smallItemSumWidth);
            } else {
                stillActiveItem = getActiveItem(slot);
                sizes = new getItemSizes(slot, stillActiveItem, stillActiveItem);
                shrinkOldActiveItem(slot, stillActiveItem, 100, sizes);
                animateBorder(sizes);
                animateTextSmall(sizes, 100);
            }
        }

        function sliderAction(nextStep, stepValue, position, uiValue, itemCount, sizes, activeItem, slot) {
            if (nextStep != stepValue) {
                if (position < uiValue && uiValue != 0 && uiValue < itemCount * sizes.smallItemSumWidth) {
                    var activeItem = stepValue;
                    slideRight(stepValue, slot);
                } else {
                    activeItem = stepValue;
                    slideLeft(stepValue, slot);
                }
                position = uiValue;
                nextStep = stepValue;
            }
            return {
                position: position,
                nextStep: nextStep,
                activeItem: activeItem
            };
        }

        function scaleImage(item) {
            var slot = $(item).parents(".carouselBox").attr("id");
            if (typeof slot !== "undefined") {
                slot = "#" + slot;
                var carouselType = slots[slot].type;
                var brandCarousel = false;
                var scale = null;
                pictureHeight = $(item).height();
                if (pictureHeight == 0) {
                    $(slot).css('display', 'block');
                    $(slot).parents('.PCmaSwitch').css('display', 'block');
                    pictureHeight = $(item).height();
                    pictureWidth = $(item).width();
                    $(slot).parents('.PCmaSwitch').css('display', 'none');
                    $(slot).css('display', 'none');
                } else {
                    pictureWidth = $(item).width();
                }
                if ($(item).parents("ul").parent("div").attr("id") == "brandCarousel") {
                    brandCarousel = true;
                }
                if ($(item).parents(".js_itemBox").attr("class") != undefined) {
                    $(item).removeAttr('style');
                    if ($(item).parents(".js_itemBox").parent('li').attr("class").indexOf("activeItem") == -1) {
                        if (pictureWidth > pictureHeight) {
                            $(item).css('width', carouselType.itemSmallWidth + "px");
                            scale = carouselType.itemSmallWidth / pictureWidth;
                            $(item).css('margin-top', (carouselType.itemSmallWidth - (pictureHeight * scale)) / 2 + 'px');
                        } else {
                            $(item).css('height', carouselType.itemSmallHeight + 'px');
                        }
                    } else {
                        if (!brandCarousel) {
                            if (pictureWidth > pictureHeight) {
                                $(item).css('width', carouselType.focusItemWidth + 'px');
                                scale = carouselType.focusItemWidth / pictureWidth;
                                $(item).css('margin-top', (carouselType.focusItemWidth - (pictureHeight * scale)) / 2 + 'px');
                            } else {
                                $(item).css('height', carouselType.focusItemHeight + 'px');
                            }
                        } else {
                            if (pictureWidth > pictureHeight) {
                                scale = carouselType.smallItemWidth / pictureWidth;
                                $(item).css('margin-top', (carouselType.smallItemWidth - (pictureHeight * scale)) / 2 + 'px');
                            } else {
                                $(item).css('height', carouselType.smallItemHeight + 'px');
                            }
                        }
                    }
                }
            }
        }

        function animateFocusItemSize(sizes, speed, carouselType) {
            sizes.thisItemBox.animate({
                height: carouselType.focusItemHeight + "px",
                width: carouselType.focusItemWidth + "px"
            }, speed);
            setPictureSize(sizes.thisItemPicture, speed, carouselType.focusItemWidth + "px");
            sizes.thisTextBox.animate({
                width: carouselType.focusItemTextBox + 'px',
                fontSize: carouselType.focusItemFontSize + "px"
            }, speed);
        }

        function shrinkOldActiveItem(slot, aitem, speed, sizes) {
            var image = $(slot + " .js_listItem_" + aitem + " .js_itemBox a img");
            setPictureSize(image, speed, sizes.smallItemWidth + "px");
            sizes.thisTextBox.animate({
                width: '120px',
                fontSize: "11px"
            }, speed);
            $(slot + " .js_listItem_" + aitem + " .js_itemBox").animate({
                height: sizes.smallItemHeight + "px",
                width: sizes.smallItemWidth + "px"
            }, speed);
            $(slot + " .js_listItem_" + aitem + " .js_itemBox").removeClass("itemActive");
        }

        function animateBorder(sizes) {
            if (typeof pageType !== 'undefined' && pageType[0] === 'articleview') {
                var slotName = sizes.thisItemBox.parents('.carouselBox').attr('id');
            }
            sizes.thisItemBox.css({
                borderWidth: "3px",
                borderTopColor: colorValueModul,
                borderRightColor: colorValueModul,
                borderBottomColor: colorValueModul,
                borderLeftColor: colorValueModul
            });
        }

        function animateAllBorders(sizes, slot) {
            var focusItemBorderWidth = slots[sizes.slot].type.focusItemBorderWidth;
            var smallItemBorderWidth = slots[sizes.slot].type.smallItemBorderWidth;
            var smallItemBorderColor = slots[sizes.slot].type.smallItemBorderColor;
            sizes.thisItemBox.css({
                borderWidth: focusItemBorderWidth + "px",
                borderTopColor: colorValueModul,
                borderRightColor: colorValueModul,
                borderBottomColor: colorValueModul,
                borderLeftColor: colorValueModul
            });
            var oldActiveItem = ".js_listItem" + slots[slot].oldActiveItem;
            $(oldActiveItem).children(".js_itemBox").css({
                borderWidth: smallItemBorderWidth + "px",
                borderTopColor: smallItemBorderColor,
                borderRightColor: smallItemBorderColor,
                borderBottomColor: smallItemBorderColor,
                borderLeftColor: smallItemBorderColor
            });
        }

        function animateTextLarge(sizes, speed) {
            sizes.nextItemText.animate({
                fontSize: slots[sizes.slot].type.focusItemFontSize + 'px',
                width: slots[sizes.slot].type.focusItemTextBox + 'px'
            }, speed);
        }

        function animateTextSmall(sizes, speed) {
            sizes.nextItemText.animate({
                fontSize: slots[sizes.slot].type.smallItemFontSize + 'px',
                width: sizes.smallItemWidth + "px"
            }, speed);
        }

        function getActiveItem(slot) {
            if (slots[slot] != undefined) {
                activeItem = slots[slot].activeItem;
                if (activeItem != null) {
                    return activeItem;
                } else {
                    return null;
                }
            } else {
                activeItem = $(slot + " .activeItem").attr('class');
                if (activeItem) {
                    slotItems = activeItem.split(" ");
                    itemCount = 1;
                    for (i = 0; i < slotItems.length; i++) {
                        if (slotItems[i].indexOf("js_listItem_") != -1) {
                            activeItem = slotItems[i].split("_");
                            break;
                        }
                    }
                    return activeItem[2];
                } else {
                    return null;
                }
            }
        }

        function setActiveClass(sizes) {
            sizes.nextItemBox.addClass("itemActive");
        }

        function setPictureSize(item, speed, value) {
            var pictureWidth = item.width();
            var pictureHeight = item.height();
            var scale = parseInt(value) / pictureWidth;
            scale = (parseInt(value) - (pictureHeight * scale)) / 2 + 'px';
            if (pictureHeight < pictureWidth) {
                item.animate({
                    width: value,
                    marginTop: scale
                }, speed);
            } else {
                item.animate({
                    height: value,
                    marginTop: '0px'
                }, speed);
            }
        }

        function getAllIlItems(slot) {
            var items = $(slot + " li");
            return items.length;
        }

        function getItems(slot) {
            var items = $(slot + " li a img");
            return items;
        }

        function getTotalItemWidth(slot) {
            var item = $(slot + " ul li:first");
            var totalWidth = parseInt(item.css('width'));
            if (!isNaN(parseInt(item.css("padding-left"))) && !isNaN(parseInt(item.css("padding-right")))) {
                totalWidth += parseInt(item.css("padding-left")) + parseInt(item.css("padding-right"));
            }
            if (!isNaN(parseInt(item.css("margin-left"))) && !isNaN(parseInt(item.css("margin-right")))) {
                totalWidth += parseInt(item.css("margin-left")) + parseInt(item.css("margin-right"));
            }
            if (!isNaN(parseInt(item.css("borderLeftWidth"))) && !isNaN(parseInt(item.css("borderRightWidth")))) {
                totalWidth += parseInt(item.css("borderLeftWidth")) + parseInt(item.css("borderRightWidth"));
            }
            return totalWidth;
        }

        function changeItem(slot, activeItem, direction, style, controlMainImage, visibleItemsInCarousel) {
            itemTotalWidth = getTotalItemWidth(slot);
            itemCount = getAllIlItems(slot);
            var imagePosition = "";
            if (direction == "clickedImage") {
                if (activeItem.indexOf("|") != -1) {
                    var activeItems = activeItem.split("|");
                    var oldActiveItem = activeItems[0];
                    var newActiveItem = activeItems[1];
                    actualUlPosition = $(slot + " .productThumbCarouselList").css('left').replace("px", "");
                    postionSecondLastImage = (itemCount - visibleItemsInCarousel) * (-itemTotalWidth);
                    positionLastImage = (itemCount - visibleItemsInCarousel) * (-itemTotalWidth);
                    positionSecondImage = 0;
                    positionFirstImage = 0;
                    if (itemCount > visibleItemsInCarousel) {
                        switch (itemCount - newActiveItem) {
                            case 0:
                                {
                                    $(slot + ' ul').animate({
                                        'left': positionLastImage + 'px'
                                    }, 200);
                                    activeItem = newActiveItem;
                                }
                                break;
                            case 1:
                                {
                                    $(slot + ' ul').animate({
                                        'left': postionSecondLastImage + 'px'
                                    }, 200);
                                    activeItem = newActiveItem;
                                }
                                break;
                            case (itemCount - 1):
                                {
                                    $(slot + ' ul').animate({
                                        'left': positionFirstImage + 'px'
                                    }, 200);
                                    activeItem = newActiveItem;
                                }
                                break;
                            case (itemCount - 2):
                                {
                                    $(slot + ' ul').animate({
                                        'left': positionSecondImage + 'px'
                                    }, 200);
                                    activeItem = newActiveItem;
                                }
                                break;
                            default:
                                {
                                    moveDiff = (parseInt((newActiveItem * itemTotalWidth)) + parseInt(actualUlPosition)) - (3 * parseInt(itemTotalWidth));
                                    $(slot + ' ul').animate({
                                        'left': '-=' + moveDiff + 'px'
                                    }, 200);
                                    activeItem = newActiveItem;
                                }
                                break;
                        }
                    } else {
                        activeItem = newActiveItem;
                    }
                }
            } else {
                resetSlot = false;
                $(slot + " .js_listItem_" + activeItem).removeClass("activeItem");
                if (style == "scrollEveryTime") {
                    if (direction == "up" && activeItem != (itemCount)) {
                        $(slot + ' ul').animate({
                            'left': '-=' + itemTotalWidth + 'px'
                        }, 200);
                        activeItem++;
                    } else if (direction == "down" && activeItem != 1) {
                        $(slot + ' ul').animate({
                            'left': '+=' + itemTotalWidth + 'px'
                        }, 200);
                        activeItem--;
                    }
                    $(slot + " .js_listItem_" + activeItem).addClass("activeItem");
                } else {
                    if (direction == "up" && imagePosition == "") {
                        activeItem++;
                    } else if (direction == "down" && imagePosition == "") {
                        activeItem--;
                    }
                    $(slot + " .js_listItem_" + activeItem).addClass("activeItem");
                    if (direction == "up") {
                        if (activeItem > 3 && activeItem < (itemCount - 1)) {
                            $(slot + ' ul').animate({
                                'left': '-=' + itemTotalWidth + 'px'
                            }, 200);
                        }
                    } else {
                        if (activeItem > 2 && activeItem < (itemCount - 2)) {
                            $(slot + ' ul').animate({
                                'left': '+=' + itemTotalWidth + 'px'
                            }, 200);
                        }
                    }
                }
            }
            if (itemCount > visibleItemsInCarousel) {
                if (slot == "#slot_reviewSliderBox" && spritesActive) {
                    if (activeItem == itemCount) {
                        $(slot + " .js_nextProductImage span").removeClass(reviewCarouselButtonRight);
                        $(slot + " .js_nextProductImage span").addClass(reviewCarouselButtonRightLastItem);
                        $(slot + " .js_nextProductImage").addClass("mouseCursorDefault");
                    } else if (activeItem == 1) {
                        $(slot + " .js_previousProductImage span").removeClass(reviewCarouselButtonLeft);
                        $(slot + " .js_previousProductImage span").addClass(reviewCarouselButtonLeftLastItem);
                        $(slot + " .js_previousProductImage").addClass("mouseCursorDefault");
                    } else if (activeItem < itemCount && activeItem > 1) {
                        $(slot + " .js_nextProductImage span").addClass(reviewCarouselButtonRight);
                        $(slot + " .js_nextProductImage span").removeClass(reviewCarouselButtonRightLastItem);
                        $(slot + " .js_nextProductImage").removeClass("mouseCursorDefault");
                        $(slot + " .js_previousProductImage span").removeClass(reviewCarouselButtonLeftLastItem);
                        $(slot + " .js_previousProductImage span").addClass(reviewCarouselButtonLeft);
                        $(slot + " .js_previousProductImage").removeClass("mouseCursorDefault");
                    }
                } else if (slot == "#slot_reviewSliderBox" && !spritesActive) {
                    if (activeItem == itemCount) {
                        $(slot + " .js_nextProductImage img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_ende_rechts.gif");
                        $(slot + " .js_nextProductImage").addClass("mouseCursorDefault");
                    } else if (activeItem == 1) {
                        $(slot + " .js_previousProductImage img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_ende_links.gif");
                        $(slot + " .js_previousProductImage").addClass("mouseCursorDefault");
                    } else if (activeItem < itemCount && activeItem > 1) {
                        $(slot + " .js_nextProductImage img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_navi_rechts.gif");
                        $(slot + " .js_nextProductImage").removeClass("mouseCursorDefault");
                        $(slot + " .js_previousProductImage img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_navi_links.gif");
                        $(slot + " .js_previousProductImage").removeClass("mouseCursorDefault");
                    }
                } else {
                    if (activeItem == itemCount) {
                        $(slot + " .js_nextProductImage").hide();
                    }
                    if (activeItem == 1) {
                        $(slot + " .js_previousProductImage").hide();
                    }
                    if (activeItem < itemCount) {
                        $(slot + " .js_nextProductImage").show();
                    }
                    if (activeItem > 1) {
                        $(slot + " .js_previousProductImage").show();
                    }
                }
            }
            if (controlMainImage == "changeMainImage") {
                dv.displayRoleName(slot, activeItem);
                var image = dv.getImageFromCarousel(slot, activeItem);
                dv.changeMainImage(image);
            }
        }

        function createCarousel(slot) {
            var carouselType = slots[slot].type;
            var activeItem = slots[slot].activeItem;
            var items = getItems(slot);
            var itemCount = items.length;
            var counter = 0;
            var listItemCounter = 1;
            $(slot + " ul li").each(function () {
                $(this).addClass("js_listItem_" + listItemCounter);
                if (listItemCounter == activeItem) {
                    $(this).addClass("js_listItem_" + listItemCounter).addClass("activeItem");
                } else {
                    $(this).addClass("js_listItem_" + listItemCounter);
                }
                listItemCounter++;
            });
            if (itemCount < carouselType.visibleItems && typeof carouselType.createLi !== "undefined") {
                carouselType.createLi(itemCount, slot, carouselType.visibleItems);
            }
        }

        function createProductPictureCarousel(slot, renderAction, carouselType) {
            var items = getItems(slot);
            if (items.length > 0) {
                var activeItem = getActiveItem(slot);
                if (activeItem == null) {
                    activeItem = 1;
                }
                if (items.length > 5) {
                    $(slot).siblings().children(".js_nextProductImage").show();
                }
                if (renderAction == "carousel") {
                    $(slot).addClass('js_carouselBox');
                    var itemCount = items.length;
                    $(slot + 'li:eq(0)').addClass("activeItem");
                    var counter = 1;
                    var activeLi = false;
                    items.each(function (index) {
                        if (!activeLi) {
                            $(this).parents("li").addClass("js_listItem_" + counter + " activeItem");
                            activeLi = true;
                        } else
                            $(this).parents("li").addClass("js_listItem_" + counter);
                        counter++;
                    });
                }
                activeImage = dv.getImageFromCarousel(slot, activeItem);
                var ulWidth = getTotalItemWidth(slot);
                $(slot + " ul").width((ulWidth * items.length) + 100);
                if (carouselType != "video")
                    dv.changeMainImage(activeImage);
            }
        }

        function createLi(itemCount, slot, carouselType) {
            var size = carouselType;
            var outputEmptyLi = "<li class=\"emptyLi\">&nbsp;</li>";
            var leftSpaceCount = Math.ceil((size - itemCount) / 2);
            var rightSpaceCount = Math.floor((size - itemCount) / 2);
            var outputStringL = "";
            var outputStringR = "";
            for (var i = 0; i < leftSpaceCount; i++) {
                outputStringL += outputEmptyLi;
            }
            $(slot + " ul").prepend(outputStringL);
            for (var i = 0; i < rightSpaceCount; i++) {
                outputStringR += outputEmptyLi;
            }
            $(slot + " ul").append(outputStringR);
        }

        function renderReviewCarousel(slot) {
            reviewImages = $(slot + " img");
            if (reviewImages.length > 0) {
                firstImage = $(slot + " img:first");
                var carouselOutput = "";
                var itemCounter = 0;
                var activeLi = false;
                var listItemCounter = 0;
                reviewImages.each(function (index) {
                    if (!activeLi) {
                        listItemCounter++;
                        carouselOutput += "<li class=\"js_listItem_" + (listItemCounter) + " activeItem\"><a href=\"#Testberichte\" class=\"js_TabLink\">";
                        activeLi = true;
                    } else if (activeLi) {
                        if (itemCounter == 3) {
                            listItemCounter++;
                            carouselOutput += "<li class=\"js_listItem_" + (listItemCounter) + "\"><a href=\"#Testberichte\" class=\"js_TabLink\">";
                            itemCounter = 0;
                        }
                    }
                    if ($(this).width() > 100) {
                        itemCounter++;
                        if (itemCounter == 3) {
                            listItemCounter++;
                            carouselOutput += "</a></li><li class=\"js_listItem_" + (listItemCounter) + "\"><a href=\"#\">";
                            itemCounter = 1;
                        }
                    }
                    if (itemCounter < 3) {
                        carouselOutput += "<img src=\"" + $(this).attr("src") + "\" alt=\"\"/>";
                    }
                    if (itemCounter == 2) {
                        carouselOutput += "</a></li>";
                    }
                    itemCounter++;
                });
                carouselOutput += "</a></li>";
                $(slot).html(carouselOutput);
                $(slot).parent("div").parent("div").css('visibility', 'visible');
                var reviewItems = $(slot + " li");
                $(slot).parents().siblings("#reviewSlidesNavigation").children("a").show();
                $(slot).parents().siblings("#reviewSlidesNavigation").children(".js_nextProductImage").addClass("mouseCursorDefault");
                if (spritesActive) {
                    $(slot).parents().siblings("#reviewSlidesNavigation").children(".js_nextProductImage").children("." + reviewCarouselButtonRight).addClass(reviewCarouselButtonRightLastItem);
                } else {
                    $(slot).parents().siblings("#reviewSlidesNavigation").children(".js_nextProductImage").children("img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_ende_rechts.gif");
                }
            }
        }
        $(".js_previousProductImage").bind('click', function () {
            var slot = $(this).parent().parent().attr('id');
            slot = "#" + slot;
            activeItem = getActiveItem(slot);
            if (slot == "#slot_videoStream") {
                changeItem(slot, activeItem, "down", "scrollEveryTime", "noChange", 5);
            } else if (slot == "#slot_reviewSliderBox") {
                changeItem(slot, activeItem, "down", "scrollEveryTime", "noChange", 1);
            } else {
                changeItem(slot, activeItem, "down", "scrollInCenter", "changeMainImage", 5);
            }
        });
        $(".js_nextProductImage").bind('click', function () {
            var slot = $(this).parent().parent().attr('id');
            slot = "#" + slot;
            activeItem = getActiveItem(slot);
            if (slot == "#slot_videoStream") {
                changeItem(slot, activeItem, "up", "scrollEveryTime", "noChange", 5);
            } else if (slot == "#slot_reviewSliderBox") {
                changeItem(slot, activeItem, "up", "scrollEveryTime", "noChange", 1);
            } else {
                changeItem(slot, activeItem, "up", "scrollInCenter", "changeMainImage", 5);
            }
        });
        $('#reviewSlidesNavigation .js_previousProductImage').mouseenter(function () {
            if (spritesActive) {
                $(this).children("span").addClass(reviewCarouselButtonLeftHover);
            } else if ($(this).children("img").attr("src").indexOf("ende") == -1) {
                $(this).children("img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_over_links.gif");
            }
        });
        $('#reviewSlidesNavigation .js_nextProductImage').mouseenter(function () {
            if (spritesActive) {
                $(this).children("span").addClass(reviewCarouselButtonRightHover);
            } else if ($(this).children("img").attr("src").indexOf("ende") == -1) {
                $(this).children("img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_over_rechts.gif");
            }
        });
        $('#reviewSlidesNavigation .js_previousProductImage').mouseleave(function () {
            if (spritesActive) {
                $(this).children("span").removeClass(reviewCarouselButtonLeftHover);
            } else if ($(this).children("img").attr("src").indexOf("ende") == -1) {
                $(this).children("img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_navi_links.gif");
            }
        });
        $('#reviewSlidesNavigation .js_nextProductImage').mouseleave(function () {
            if (spritesActive) {
                $(this).children("span").removeClass(reviewCarouselButtonRightHover);
            } else if ($(this).children("img").attr("src").indexOf("ende") == -1) {
                $(this).children("img").attr("src", "/is-bin/intershop.static/WFS/Otto-OttoDe-Site/-/de_DE/imagesOnline/misc/ads_testberichte_navi_rechts.gif");
            }
        });
        this.resolveCarouselType = resolveCarouselType;
        this.slideCarousel = slideCarousel;
        this.scaleImage = scaleImage;
        this.renderReviewCarousel = renderReviewCarousel;
        this.getActiveItem = getActiveItem;
        this.changeItem = changeItem;
        this.createProductPictureCarousel = createProductPictureCarousel;
    }();
$(".WT_FEAT_APELINK").live("click", function () {
    if (typeof pageType !== 'undefined' && pageType[0] === 'articleview') {
        var slotName = $(this).parents('.carouselBox').attr('id');
    }
});;
(function ($) {
    $.fn.massartikel = function (options) {
        var settings = $.extend({
            'minQuantity': '30',
            'maxQuantity': '150',
            'incrementQuantity': '1',
            'unit': 'cm',
            'unitName': 'Maßeinheit',
            'startValue': '0'
        }, options);
        var id = $(this).attr('id');
        var parent = $('#' + id);
        var size = settings.maxQuantity.length;
        parent.append('<div id="' + id + '_unit" class="massart_unit">' + settings.unitName + ' (' + settings.unit + ')</div>' + '<div id="' + id + '_slider" class="js_massSlider massSlider"></div>' + '<div class="sld_minmax"><span class="FLeft js_min">' + settings.minQuantity + '</span>' + '<span class="FRight js_max">' + settings.maxQuantity + '</span><br class="clearboth;" /></div>' + '<span class="no_error massInp">' + '<input type="text" maxlength="' + size + '" id="' + id + '_inp" class="js_massInp " value="' + settings.minQuantity + '" /></span>' + '<br class="clearboth;" />');
        var slider = parent.find('.js_massSlider');
        var input = parent.find('.js_massInp');
        var inpWrp = input.parents('.massInp');
        var selectedValue = 0;
        var keyPressed = 0
        var allowedKeys = new Array(8, 9, 13, 37, 38, 39, 40, 46, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102, 103, 104, 105);
        init = function (settings) {
            var sld = slider.css('position', 'relative').slider({
                min: parseInt(settings.minQuantity),
                max: parseInt(settings.maxQuantity),
                step: parseInt(settings.incrementQuantity),
                change: function (event, ui) {
                    input.val(ui.value);
                    selectedValue = ui.value;
                    jQuery.data(parent, 'selectedValue', ui.value);
                    checkAllInputs();
                },
                slide: function (event, ui) {
                    input.val(ui.value);
                    selectedValue = ui.value;
                    jQuery.data(parent, 'selectedValue', ui.value);
                    checkAllInputs();
                }
            });
            if (parseInt(settings.startValue) < parseInt(settings.minQuantity)) {
                slider.slider({
                    value: parseInt(settings.minQuantity)
                });
            } else if (parseInt(settings.startValue) > parseInt(settings.maxQuantity)) {
                slider.slider({
                    value: parseInt(settings.maxQuantity)
                });
            } else {
                slider.slider({
                    value: parseInt(settings.startValue)
                });
            }
        }, getVal = function () {
            return selectedValue;
        }, checkAllInputs = function () {
            var inputs = $('.js_massInp');
            var arrFailure = new Array();
            var arrFine = new Array();
            inputs.each(function () {
                var objElement = $(this);
                var inpVal = objElement.val();
                var parent = objElement.parents('.mart');
                var min = parent.find('.js_min').html();
                var max = parent.find('.js_max').html();
                var errorField = $('#mA_errField');
                var objInpWrp = objElement.parent();
                if (objInpWrp.hasClass('error')) {
                    objInpWrp.removeClass('error');
                }
                jQuery.data(objElement, 'min', min);
                jQuery.data(objElement, 'max', max);
                if (inpVal.match('^[0-9]+$') != null) {
                    inpVal = parseInt(inpVal);
                    if (isNaN(inpVal) || inpVal < parseInt(min) || inpVal > parseInt(max)) {
                        arrFailure.push(objElement);
                    } else {
                        arrFine.push(objElement);
                    }
                } else {
                    arrFailure.push(objElement);
                }
                if (arrFailure.length > 0) {
                    for (i = 0; i < arrFailure.length; i++) {
                        arrFailure[i].parent('.massInp').addClass('error');
                        errorField.find('#mA_min').html(jQuery.data(arrFailure[i], 'min'));
                        errorField.find('#mA_max').html(jQuery.data(arrFailure[i], 'max'));
                    }
                    errorField.show(1);
                } else {
                    $('#mA_errField').hide(1);
                }
            });
        };
        input.keydown(function (e) {
            var keyCode = e.keyCode;
            if (keyCode == 16) {
                return false;
            }
            var inpVal = $(this).val();
            if (keyPressed >= 1) {
                allowedKeys.push(48);
                allowedKeys.push(96);
            }
            if (jQuery.inArray(keyCode, allowedKeys) == -1) {
                keyPressed = 0;
                if (inpVal.length >= 1) {
                    keyPressed++;
                }
                return false;
            } else {
                keyPressed++;
            }
        });
        input.keyup(function (e) {
            var inpVal = $(this).val().replace(/^(0+)/g, '');
            var keyCode = e.keyCode;
            if (inpVal.match('^[0-9]+$') != null) {
                inpVal = parseInt(inpVal);
                if (inpVal >= parseInt(settings.minQuantity) && inpVal <= parseInt(settings.maxQuantity)) {
                    if (inpVal >= parseInt(settings.minQuantity)) {
                        slider.slider({
                            value: inpVal
                        });
                        selectedValue = inpVal;
                    } else {
                        slider.slider({
                            value: settings.minQuantity
                        });
                        selectedValue = settings.minQuantity;
                    }
                    if (inpVal <= parseInt(settings.maxQuantity)) {
                        slider.slider({
                            value: inpVal
                        });
                        selectedValue = inpVal;
                    } else {
                        slider.slider({
                            value: settings.maxQuantity
                        });
                        selectedValue = settings.maxQuantity;
                    }
                }
            }
            if (keyCode == 13) {
                input.blur();
                keyPressed = 0;
                return true;
            }
        });
        input.blur(function () {
            var inpVal = $(this).val().replace(/^(0+)/g, '');
            if (inpVal == '' || $.trim(inpVal) == '') {
                inpWrp.addClass('error');
                $('#mA_errField').show(1);
                $('#mA_errField').find('#mA_min').html(settings.minQuantity);
                $('#mA_errField').find('#mA_max').html(settings.maxQuantity);
                keyPressed = 0;
            } else {
                checkAllInputs();
            }
        });
        init(settings);
        return {
            init: init,
            getVal: getVal
        };
    };
})(jQuery);;
jQuery.ObjGalery = function () {
    var
    SlideShows = [],
        ActivSliderShow = 0,
        CurrentSlideShow, ActivImageKey = 0,
        intImageCount, init = function (settings) {
            SlideShows = settings;
            if (SlideShows[0]) {
                CurrentSlideShow = SlideShows[0];
                intImageCount = CurrentSlideShow.length;
                if (intImageCount < 2) {
                    $('#GaleryPrevious').hide();
                    $('#GaleryNext').hide();
                    $('#GaleryCounter').hide();
                } else {
                    $('#GaleryPrevious').show();
                    $('#GaleryNext').show();
                    $('#GaleryCounter').show();
                }
                setAction();
                $('.GaleryImageSet').click(function () {
                    var NewImageSet = parseInt($(this).attr('ImageSet'));
                    if (NewImageSet != ActivSliderShow) {
                        $('.PicActive').removeClass('PicActive');
                        $(this).children('img').addClass('PicActive');
                        ActivImageKey = 0;
                        ActivSliderShow = NewImageSet;
                        action(NewImageSet);
                    }
                })
            }
        }, action = function (intSettingId) {
            CurrentSlideShow = SlideShows[intSettingId];
            intImageCount = CurrentSlideShow.length;
            if (intImageCount < 2) {
                $('#GaleryPrevious').hide();
                $('#GaleryNext').hide();
                $('#GaleryCounter').hide();
            } else {
                $('#GaleryPrevious').show();
                $('#GaleryNext').show();
                $('#GaleryCounter').show();
            }
            setAction();
        }
    previous = function () {
        ActivImageKey--;
        if (ActivImageKey < 0) {
            ActivImageKey = intImageCount - 1
        }
        $('#GaleryImage').fadeOut('slow', function () {
            setAction();
            $('#GaleryImage').fadeIn('slow');
        })
    }, next = function () {
        ActivImageKey++;
        if (ActivImageKey == intImageCount) {
            ActivImageKey = 0;
        }
        $('#GaleryImage').fadeOut('slow', function () {
            setAction();
            $('#GaleryImage').fadeIn('slow');
        })
    }, setAction = function () {
        $('#GaleryImage').attr('src', CurrentSlideShow[ActivImageKey].image);
        $('#GaleryImage').attr('alt', CurrentSlideShow[ActivImageKey].alt);
        $('#GaleryLink').attr('href', CurrentSlideShow[ActivImageKey].url);
        $('#GaleryCounter').html(bild + ' ' + (ActivImageKey + 1) + ' ' + von + ' ' + intImageCount);
    }
    return {
        init: init,
        previous: previous,
        next: next
    };
}();
$(document).ready(function () {
    if (PictureSlidesSet != null && PictureSlidesSet != undefined) {
        jQuery.ObjGalery.init(PictureSlidesSet);
    }
});;
(function (m) {
    jQuery.fn.pngFix = function (c) {
        c = jQuery.extend({
            blankgif: 'blank.gif'
        }, c);
        var e = (navigator.appName == "Microsoft Internet Explorer" && parseInt(navigator.appVersion) == 4 && navigator.appVersion.indexOf("MSIE 5.5") != -1);
        var f = (navigator.appName == "Microsoft Internet Explorer" && parseInt(navigator.appVersion) == 4 && navigator.appVersion.indexOf("MSIE 6.0") != -1);
        if (jQuery.browser.msie && (e || f)) {
            jQuery(this).find("img[src$=.png]").each(function () {
                jQuery(this).attr('width', jQuery(this).width());
                jQuery(this).attr('height', jQuery(this).height());
                var a = '';
                var b = '';
                var g = (jQuery(this).attr('id')) ? 'id="' + jQuery(this).attr('id') + '" ' : '';
                var h = (jQuery(this).attr('class')) ? 'class="' + jQuery(this).attr('class') + '" ' : '';
                var i = (jQuery(this).attr('title')) ? 'title="' + jQuery(this).attr('title') + '" ' : '';
                var j = (jQuery(this).attr('alt')) ? 'alt="' + jQuery(this).attr('alt') + '" ' : '';
                var k = (jQuery(this).attr('align')) ? 'float:' + jQuery(this).attr('align') + ';' : '';
                var d = (jQuery(this).parent().attr('href')) ? 'cursor:hand;' : '';
                if (this.style.border) {
                    a += 'border:' + this.style.border + ';';
                    this.style.border = ''
                }
                if (this.style.padding) {
                    a += 'padding:' + this.style.padding + ';';
                    this.style.padding = ''
                }
                if (this.style.margin) {
                    a += 'margin:' + this.style.margin + ';';
                    this.style.margin = ''
                }
                var l = (this.style.cssText);
                b += '<span ' + g + h + i + j;
                b += 'style="position:relative;white-space:pre-line;display:inline-block;background:transparent;' + k + d;
                b += 'width:' + jQuery(this).width() + 'px;height:' + jQuery(this).height() + 'px;';
                b += 'filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + jQuery(this).attr('src') + '\', sizingMethod=\'scale\');';
                b += l + '"></span>';
                if (a != '') {
                    b = '<span style="position:relative;display:inline-block;' + a + d + 'width:' + jQuery(this).width() + 'px;height:' + jQuery(this).height() + 'px;">' + b + '</span>'
                }
                jQuery(this).hide();
                jQuery(this).after(b)
            });
            jQuery(this).find("*").each(function () {
                var a = jQuery(this).css('background-image');
                if (a.indexOf(".png") != -1) {
                    var b = a.split('url("')[1].split('")')[0];
                    jQuery(this).css('background-image', 'none');
                    jQuery(this).get(0).runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + b + "',sizingMethod='scale')"
                }
            });
            jQuery(this).find("input[src$=.png]").each(function () {
                var a = jQuery(this).attr('src');
                jQuery(this).get(0).runtimeStyle.filter = 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\'' + a + '\', sizingMethod=\'scale\');';
                jQuery(this).attr('src', c.blankgif)
            })
        }
        return jQuery
    }
})(jQuery);;;
if (window.jQuery)(function ($) {
        var methods = {
            init: function (options) {
                return this.each(function () {
                    options = $.extend({
                        control_right_img_on: 'general/images/arrow/slider_right_active.png',
                        control_right_img_off: 'general/images/arrow/slider_right_inactive.png',
                        control_left_img_on: 'general/images/arrow/slider_left_active.png',
                        control_left_img_off: 'general/images/arrow/slider_left_inactive.png',
                        injectDiv: '.js_sliderInject',
                        actLeft: '.js_left',
                        actRight: '.js_right',
                        slideTime: 300,
                        sliderElements: ['6315863.jpg', '6315864.jpg', '6315844.jpg'],
                        sliderUrl: 'http://mmo.scene7.com/asset/mmo/ov_formats/',
                        sliderStart: 0
                    }, options);
                    var wrapper = $(this);
                    var objPositions = new Array();
                    var mxSldStart = options.sliderStart;
                    var darfSliden = true;
                    var sldActRight = wrapper.find(options.actRight);
                    var sldActLeft = wrapper.find(options.actLeft);
                    wrapper.attr('sCount', options.sliderStart);
                    var sperre = function (zustand) {
                        darfSliden = zustand;
                    }
                    var rollRight = function (sliderObj) {
                        slider = sliderObj.slider;
                        sldActLeft = sliderObj.sldActLeft;
                        sldActRight = sliderObj.sldActRight;
                        if (darfSliden) {
                            sperre(false);
                            if (mxSldStart >= 0) {
                                mxSldStart++;
                                wrapper.attr('sCount', mxSldStart);
                            }
                            slider.animate({
                                left: -1 * objPositions[mxSldStart].position
                            }, options.slideTime, function () {
                                sperre(true);
                                toggleButton(sldActLeft, 'active');
                                if (mxSldStart >= (options.sliderElements.length - 1)) {
                                    toggleButton(sldActRight, 'inactive');
                                }
                            });
                            return false;
                        } else {
                            return false;
                        }
                    }
                    var rollLeft = function (sliderObj) {
                        slider = sliderObj.slider;
                        sldActLeft = sliderObj.sldActLeft;
                        sldActRight = sliderObj.sldActRight;
                        if (darfSliden) {
                            sperre(false);
                            if (mxSldStart > 0) {
                                mxSldStart--;
                                wrapper.attr('sCount', mxSldStart);
                            }
                            slider.animate({
                                left: -1 * objPositions[mxSldStart].position
                            }, options.slideTime, function () {
                                sperre(true);
                                if (mxSldStart < 1) {
                                    toggleButton(sldActLeft, 'inactive');
                                }
                                toggleButton(sldActRight, 'active');
                            });
                            return false;
                        } else {
                            return false;
                        }
                    }
                    var toggleButton = function (button, status) {
                        if (button == sldActRight) {
                            if (status == 'inactive') {
                                button.find('img').attr('src', options.control_right_img_off);
                                button.addClass('deactivated');
                            } else {
                                button.find('img').attr('src', options.control_right_img_on);
                                button.removeClass('deactivated');
                            }
                        } else {
                            if (status == 'inactive') {
                                button.find('img').attr('src', options.control_left_img_off);
                                button.addClass('deactivated');
                            } else {
                                button.find('img').attr('src', options.control_left_img_on);
                                button.removeClass('deactivated');
                            }
                        }
                    }
                    writeHtml = function () {
                        var wrapperWidth = 0;
                        var wrapperHeight = 0;
                        $posFix = wrapper.html('<div class="posFix"></div>');
                        $sliderWrap = $('<div class="sliderWrap"></div>');
                        $sliderInnerWrap = $('<div class="sldInnerWrap js_sldInnerWrap"></div>');
                        $sliderControl = $('<div class="slidercontrols js_sliderControl"></div>');
                        $leftActionLnk = $('<a href="javascript:void(0);" class="left deactivated js_left"><img src="" class="" alt="" /></a>');
                        $rightActionLnk = $('<a href="javascript:void(0);" class="right js_right"><img src="" class="" alt="" /></a>');
                        $sliderWrap.html($sliderInnerWrap);
                        var objSlider = new Object();
                        objSlider = {
                            slider: $sliderInnerWrap,
                            sldActLeft: $leftActionLnk,
                            sldActRight: $rightActionLnk
                        }
                        var preloader = new Array();
                        for (var i = 0; i < options.sliderElements.length; i++) {
                            preloader[i] = new Image();
                            preloader[i].src = options.sliderUrl + options.sliderElements[i];
                        }
                        var sliderElementString = "";
                        for (var i = 0; i < preloader.length; i++) {
                            sliderElementString += '<div class="sliderItem js_sliderItem"><img src="' + preloader[i].src + '" /></div>';
                        }
                        $sliderInnerWrap.html(sliderElementString);
                        $posFix.html($sliderWrap);
                        if (options.sliderElements.length > 1) {
                            $sliderControl.append($leftActionLnk).append($rightActionLnk);
                            if (mxSldStart == 0) {
                                $leftActionLnk.find('img').attr('src', options.control_left_img_off);
                            } else {
                                $leftActionLnk.find('img').attr('src', options.control_left_img_on);
                                $leftActionLnk.removeClass('deactivated');
                            }
                            if (mxSldStart >= (options.sliderElements.length - 1)) {
                                $rightActionLnk.addClass('deactivated').find('img').attr('src', options.control_right_img_off);
                                $leftActionLnk.removeClass('deactivated');
                            } else {
                                $rightActionLnk.find('img').attr('src', options.control_right_img_on);
                            }
                            $leftActionLnk.click(function () {
                                if (!$(this).hasClass('deactivated')) {
                                    rollLeft(objSlider);
                                    return false;
                                } else {
                                    return false;
                                }
                            });
                            $rightActionLnk.click(function () {
                                if (!$(this).hasClass('deactivated')) {
                                    rollRight(objSlider);
                                    return false;
                                } else {
                                    return false;
                                }
                            });
                            sliderElements = wrapper.find('.js_sliderItem');
                            slideWidth = sliderElements.first().width();
                            sliderElements.each(function (index) {
                                var singleSlide = new Object();
                                singleSlide = {
                                    domElm: $(this),
                                    position: (index * slideWidth)
                                }
                                objPositions.push(singleSlide);
                                var ew = $(this).outerWidth();
                                var eh = $(this).outerHeight();
                                if (ew > wrapperWidth) {
                                    wrapperWidth = ew;
                                }
                                if (eh > wrapperHeight) {
                                    wrapperHeight = eh;
                                }
                            });
                            if ($('body').hasClass('mobile')) {
                                $sliderControl.css({
                                    width: wrapperWidth,
                                    display: 'block'
                                });
                            } else {
                                $sliderControl.css({
                                    width: wrapperWidth,
                                    display: 'none'
                                });
                            }
                            $sliderInnerWrap.css({
                                width: (slideWidth * sliderElements.length),
                                left: -1 * objPositions[mxSldStart].position
                            });
                            wrapper.mouseenter(function () {
                                $(this).find('.js_sliderControl').stop(true, true).fadeIn('fast');
                            });
                            wrapper.mouseleave(function () {
                                $(this).find('.js_sliderControl').stop(true, true).fadeOut('fast');
                            });
                            wrapper.append($sliderControl);
                        }
                        wrapper.bind('sliderload');
                        wrapper.load(function () {
                            wrapper.trigger('sliderload');
                        });
                    }
                    writeHtml();
                });
            },
            destroy: function () {
                $(this).children().removeData();
                $(this).children().unbind();
                $(this).children().remove();
                $(this).removeAttr('sCount');
            }
        };
        $.fn.mxSlider = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist on jQuery.mxSlider');
            }
        };
    })(jQuery);;;
if (window.jQuery)(function ($) {
        $.fn.extend({
            mxColorSpot: function (options) {
                var defaults = {
                    cssclass: 'active',
                    parent: '.js_spotWrap',
                    spots: '.js_spots',
                    spot: '.js_spot',
                    toolTip: '.js_colName',
                    sliderParent: '.js_ItemParent',
                    slider: '.js_sliderInject',
                    TooltipTimer: 0,
                    TimeSet: TimeSettings['ColorSpots'],
                    control_right_img_on: 'general/images/arrow/prodList_sldRight_active.jpg',
                    control_right_img_off: 'general/images/arrow/prodList_sldRight_inactive.jpg',
                    control_left_img_on: 'general/images/arrow/prodList_sldLeft_active.jpg',
                    control_left_img_off: 'general/images/arrow/prodList_sldLeft_inactive.jpg',
                    slideTime: 300,
                    MouseOverEvent: 'event_colorSpotMouseover',
                    MouseClickEvent: 'event_colorSpotClicked',
                    TooltipEvent: 'event_colorSpotTooltip',
                    sliderStartValue: 0,
                    sld_control_right_img_on: 'general/images/arrow/slider_right_active.png',
                    sld_control_right_img_off: 'general/images/arrow/slider_right_inactive.png',
                    sld_control_left_img_on: 'general/images/arrow/slider_left_active.png',
                    sld_control_left_img_off: 'general/images/arrow/slider_left_inactive.png'
                }
                var options = $.extend(defaults, options);
                return this.each(function (index) {
                    var o = options;
                    var holder = null;
                    var wrapper = $(this);
                    var parent = wrapper.find(o.parent);
                    var spots = parent.find(o.spots);
                    var spotLi = spots.find(o.spot);
                    var spot = spotLi.find('div');
                    var slider = wrapper.parents(o.sliderParent).find(o.slider);
                    var toolTip = wrapper.find(o.toolTip);
                    var slideControl = wrapper.find('.sldControl');
                    var darfSliden = true;
                    var spotWidth = spotLi.first().outerWidth(true);
                    var parentWidth = parent.width();
                    var noControlsFor = Math.round((parentWidth / spotWidth));
                    var btnRight = slideControl.find('.js_right');
                    var btnLeft = slideControl.find('.js_left');
                    var objPositions = new Array();
                    var mxSldStart = 0;
                    var objSlider = new Object();
                    objSlider = {
                        spotslider: spots,
                        sldActLeft: slideControl.find('.js_left'),
                        sldActRight: slideControl.find('.js_right')
                    }
                    spotLi.each(function (index) {
                        var singleSlide = new Object();
                        singleSlide = {
                            domElm: $(this),
                            position: (index * spotWidth)
                        }
                        objPositions.push(singleSlide);
                    });
                    if (spotLi.length > noControlsFor) {
                        parent.parents('.colSpotsWrap').removeClass('noControls');
                        btnRight.find('img').attr('src', options.control_right_img_on);
                        btnRight.click(function () {
                            if (!$(this).hasClass('deactivated')) {
                                rollRight(objSlider);
                                return false;
                            } else {
                                return false;
                            }
                        });
                        btnLeft.addClass('deactivated').click(function () {
                            if (!$(this).hasClass('deactivated')) {
                                rollLeft(objSlider);
                                return false;
                            } else {
                                return false;
                            }
                        });
                    }
                    spot.each(function () {
                        var singlSpot = $(this);
                        if (!parent.parents('#PrdLst2').hasClass('list_1')) {
                            singlSpot.find('a').attr('title', singlSpot.attr("data-tooltip"));
                        }
                        singlSpot.mouseenter(function () {
                            var objElement = $(this);
                            var preload = objElement.attr("data-preload");
                            if (preload != undefined && preload != null) {
                                var preLoadImg = new Image();
                                preLoadImg.src = preload;
                            }
                            if (objElement.hasClass('active')) {
                                return false;
                            }
                            objElement.parents(o.parent).find('.' + o.cssclass).removeClass(o.cssclass);
                            holder = objElement;
                            holder.addClass(o.cssclass);
                            o.TimeSet = window.setTimeout(function () {
                                toolTip.html(holder.attr("data-tooltip"));
                                clearTimeout(o.TimeSet);
                                singlSpot.trigger(options.TooltipEvent);
                            }, o.TooltipTimer);
                            slider.mxSlider('destroy');
                            sliderImgs = holder.attr("data-images").split(',');
                            slider.mxSlider({
                                control_right_img_on: o.sld_control_right_img_on,
                                control_right_img_off: o.sld_control_right_img_off,
                                control_left_img_on: o.sld_control_left_img_on,
                                control_left_img_off: o.sld_control_left_img_off,
                                sliderElements: sliderImgs,
                                sliderUrl: holder.attr("data-url")
                            });
                            objElement.trigger(options.MouseOverEvent);
                        });
                        singlSpot.mouseleave(function () {
                            clearTimeout(o.TimeSet);
                        });
                        singlSpot.click(function () {
                            $(this).trigger(options.MouseClickEvent);
                        });
                    });
                    var sperre = function (zustand) {
                        darfSliden = zustand;
                    }
                    var rollRight = function (sliderObj) {
                        spotslider = sliderObj.spotslider;
                        sldActLeft = sliderObj.sldActLeft;
                        sldActRight = sliderObj.sldActRight;
                        if (darfSliden) {
                            sperre(false);
                            if (mxSldStart >= 0) {
                                mxSldStart++;
                            }
                            spotslider.animate({
                                left: -1 * objPositions[mxSldStart].position
                            }, options.slideTime, function () {
                                sperre(true);
                                toggleButton(sldActLeft, 'active');
                                if (mxSldStart >= (spotLi.length - noControlsFor)) {
                                    toggleButton(sldActRight, 'inactive');
                                }
                            });
                            return false;
                        } else {
                            return false;
                        }
                    }
                    var rollLeft = function (sliderObj) {
                        spotslider = sliderObj.spotslider;
                        sldActLeft = sliderObj.sldActLeft;
                        sldActRight = sliderObj.sldActRight;
                        if (darfSliden) {
                            sperre(false);
                            if (mxSldStart > 0) {
                                mxSldStart--;
                            }
                            spotslider.animate({
                                left: -1 * objPositions[mxSldStart].position
                            }, options.slideTime, function () {
                                sperre(true);
                                if (mxSldStart < 1) {
                                    toggleButton(sldActLeft, 'inactive');
                                }
                                toggleButton(sldActRight, 'active');
                            });
                            return false;
                        } else {
                            return false;
                        }
                    }
                    var toggleButton = function (button, status) {
                        if (button == sldActRight) {
                            if (status == 'inactive') {
                                button.find('img').attr('src', options.control_right_img_off);
                                button.addClass('deactivated');
                            } else {
                                button.find('img').attr('src', options.control_right_img_on);
                                button.removeClass('deactivated');
                            }
                        } else {
                            if (status == 'inactive') {
                                button.find('img').attr('src', options.control_left_img_off);
                                button.addClass('deactivated');
                            } else {
                                button.find('img').attr('src', options.control_left_img_on);
                                button.removeClass('deactivated');
                            }
                        }
                    }
                    if (spots.hasClass('js_sldPrevent') == false) {
                        spots.css({
                            'width': (spotWidth * spotLi.length)
                        });
                    }
                });
            }
        });
    })(jQuery);;;
if (window.jQuery)(function ($) {
        var methods = {
            init: function (options) {
                return this.each(function () {
                    options = $.extend({
                        spotClassSelector: '.js_spot',
                        MouseOverEvent: 'sizeSpotChanged',
                        ClickEvent: 'sizeSpotClicked',
                        LeaveEvent: 'sizeSpotLeft'
                    }, options);
                    wrapper = $(this);
                    var allSpots = wrapper.find(options.spotClassSelector);
                    allSpots.each(function () {
                        var actSpot = $(this);
                        actSpot.mouseover(function () {
                            if ($(this).hasClass('deactivated') || $(this).hasClass('active')) {
                                return false;
                            } else {
                                $(this).parent().find('.active').removeClass('active');
                                $(this).addClass('active').trigger(options.MouseOverEvent);
                            }
                        });
                        actSpot.mouseleave(function () {
                            if ($(this).hasClass('deactivated')) {
                                return false;
                            }
                            $(this).trigger(options.LeaveEvent);
                        });
                        actSpot.click(function () {
                            if ($(this).hasClass('deactivated')) {
                                return false;
                            }
                            $(this).trigger(options.ClickEvent);
                        });
                    });
                });
            }
        };
        $.fn.mxSizeSpot = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist on jQuery.mxSizeSpot');
            }
        };
    })(jQuery);;;
if (window.jQuery)(function ($) {
        var methods = {
            init: function (options) {
                return this.each(function () {
                    options = $.extend({
                        itemParents: '.js_ItemParent',
                        customerActions: '.customerActions',
                        sliderControl: '.js_sliderControl',
                        qvLayer: '.quickviewLayer',
                        qvDynamicContent: '.js_dynamicContent',
                        sliderInject: '.js_sliderInject',
                        sliderParent: '.js_sliderParent',
                        colSpotsWrap: '.colSpotsWrap',
                        sizeSpotsWrap: '.sizeSpotsWrap',
                        dims: '.js_dims',
                        event_init: 'productListReady',
                        event_quickviewOpen: 'quickviewOpen',
                        event_memorize_product: 'productMemorized',
                        event_dememorize_product: 'productDeMemorized',
                        event_link_dim_active: 'linkDimensionChanged',
                        btn_img_memo_inactive: 'general/images/Icons/prodList1_pin_inactive.jpg',
                        btn_img_memo_active: 'general/images/Icons/prodList1_pin_active.jpg',
                        btn_img_tooltip_memo: 'general/images/Icons/tooltipMerken.png',
                        btn_img_tooltip_memoActive: 'general/images/Icons/tooltipArtikelGemerkt.png',
                        btn_img_tooltip_detail: 'general/images/Icons/tooltipDetails.png',
                        tooltip: '#tooltipImg',
                        showTooltip: 500,
                        control_right_img_on: 'general/images/arrow/prodList_sldRight_active.jpg',
                        control_right_img_off: 'general/images/arrow/prodList_sldRight_inactive.jpg',
                        control_left_img_on: 'general/images/arrow/prodList_sldLeft_active.jpg',
                        control_left_img_off: 'general/images/arrow/prodList_sldLeft_inactive.jpg',
                        slideTime: 300,
                        MouseOverEvent: 'event_colorSpotMouseover',
                        MouseClickEvent: 'event_colorSpotClicked',
                        TooltipEvent: 'event_colorSpotTooltip',
                        size_MouseOverEvent: 'sizeSpotChanged',
                        size_ClickEvent: 'sizeSpotClicked',
                        size_LeaveEvent: 'sizeSpotLeft',
                        sld_control_right_img_on: 'general/images/arrow/slider_right_active.png',
                        sld_control_right_img_off: 'general/images/arrow/slider_right_inactive.png',
                        sld_control_left_img_on: 'general/images/arrow/slider_left_active.png',
                        sld_control_left_img_off: 'general/images/arrow/slider_left_inactive.png',
                        customQvCallBack: null
                    }, options);
                    var wrapper = $(this);
                    var qvLayer = wrapper.find(options.qvLayer);
                    var itemParents = wrapper.find(options.itemParents);
                    var colSpotsWrap = wrapper.find(options.colSpotsWrap);
                    var sizeSpotsWrap = wrapper.find(options.sizeSpotsWrap);
                    var qvDynamicContent = qvLayer.find(options.qvDynamicContent);
                    var toolTip = $(options.tooltip);
                    var TIMER = null;
                    colSpotsWrap.mxColorSpot({
                        control_right_img_on: options.control_right_img_on,
                        control_right_img_off: options.control_right_img_off,
                        control_left_img_on: options.control_left_img_on,
                        control_left_img_off: options.control_left_img_off,
                        slideTime: options.slideTime,
                        MouseOverEvent: options.MouseOverEvent,
                        MouseClickEvent: options.MouseClickEvent,
                        TooltipEvent: options.TooltipEvent,
                        sld_control_right_img_on: options.sld_control_right_img_on,
                        sld_control_right_img_off: options.sld_control_right_img_off,
                        sld_control_left_img_on: options.sld_control_left_img_on,
                        sld_control_left_img_off: options.sld_control_left_img_off
                    });
                    sizeSpotsWrap.mxSizeSpot({
                        MouseOverEvent: options.size_MouseOverEvent,
                        ClickEvent: options.size_ClickEvent,
                        LeaveEvent: options.size_LeaveEvent
                    });
                    itemParents.each(function () {
                        var productWrap = $(this);
                        var customerActions = productWrap.find(options.customerActions);
                        var sliderControl = productWrap.find(options.sliderControl);
                        var sliderInject = productWrap.find(options.sliderInject);
                        var sliderParent = productWrap.find(options.sliderParent);
                        var colSpotsWrap = productWrap.find(options.colSpotsWrap);
                        var dims = productWrap.find(options.dims);
                        var btnQuickview = customerActions.find('.js_right');
                        var btnMerken = customerActions.find('.js_left');
                        var pin = productWrap.find('.articleAction').find('.js_left');
                        var qvStyle = productWrap.attr('data-style');
                        if (sliderParent.hasClass('artPicWrap_6') == false) {
                            sliderParent.one('mouseenter', function () {
                                initSlider(colSpotsWrap, 0);
                            });
                        }
                        productWrap.find('.articleAction').find('a.pin').mouseover(function () {
                            var button = $(this);
                            var aktText = button.find('span').html();
                            var newText = button.attr('rel');
                            button.unbind('click');
                            if (button.hasClass('js_memo')) {
                                button.click(function () {
                                    button.trigger(options.event_dememorize_product).removeClass('js_memo').find('img').attr('src', options.btn_img_memo_inactive);
                                    button.find('span').html(newText);
                                    button.attr('rel', aktText);
                                });
                                return false;
                            } else {
                                button.find('img').attr('src', options.btn_img_memo_active);
                                button.mouseout(function () {
                                    if (button.hasClass('js_memo') == false) {
                                        button.find('img').attr('src', options.btn_img_memo_inactive);
                                    }
                                }).click(function () {
                                    button.trigger(options.event_memorize_product).addClass('js_memo').find('img').attr('src', options.btn_img_memo_active);
                                    button.find('span').html(newText);
                                    button.attr('rel', aktText);
                                    return false;
                                });
                                return false;
                            }
                        });

                        function initSlider(spotWrap, startValue) {
                            var cSpot = spotWrap.find('.active');
                            var sliderInject = spotWrap.parents('.js_ItemParent').find(options.sliderInject);
                            if (startValue == undefined || startValue == null) {
                                startValue = 0;
                            }
                            productWrap.find('.loadIndicator').css('display', 'block');
                            sliderInject.mxSlider('destroy');
                            sliderImgs = cSpot.attr("data-images").split(',');
                            sliderInject.mxSlider({
                                control_right_img_on: options.sld_control_right_img_on,
                                control_right_img_off: options.sld_control_right_img_off,
                                control_left_img_on: options.sld_control_left_img_on,
                                control_left_img_off: options.sld_control_left_img_off,
                                sliderElements: sliderImgs,
                                sliderUrl: cSpot.attr("data-url"),
                                sliderStart: startValue
                            });
                            productWrap.find('.loadIndicator').css('display', 'none');
                        }

                        function initCustomActions(btn, wrapper) {
                            if (wrapper != null && wrapper != undefined) {
                                if (wrapper.data('memorized') != null && wrapper.data('memorized') != undefined) {
                                    btn.addClass('js_memo').find('img').attr('src', options.btn_img_memo_active);
                                }
                            }
                            btn.mouseover(function () {
                                var button = $(this);
                                button.unbind('click');
                                if (button.hasClass('js_memo')) {
                                    setTooltipGfx(button, options.btn_img_tooltip_memoActive);
                                    button.click(function () {
                                        setTooltipGfx(button, options.btn_img_tooltip_memo);
                                        wrapper.data('memorized', null);
                                        qvL = button.parents('.quickviewLayer');
                                        if (qvL.data('caller') != null && qvL.data('caller') != undefined) {
                                            var product = qvL.data('caller');
                                            product.find(options.customerActions).find('.js_left').removeClass('js_memo').css('display', 'none').find('img').attr('src', options.btn_img_memo_inactive);
                                            qvL.data('caller', null);
                                        }
                                        button.removeClass('js_memo').trigger(options.event_dememorize_product).find('img').attr('src', options.btn_img_memo_inactive);
                                    });
                                    button.mouseout(function () {
                                        toolTip.css('display', 'none');
                                    })
                                } else {
                                    button.find('img').attr('src', options.btn_img_memo_active);
                                    setTooltipGfx(button, options.btn_img_tooltip_memo);
                                    button.mouseout(function () {
                                        if (button.hasClass('js_memo') == false) {
                                            button.find('img').attr('src', options.btn_img_memo_inactive);
                                        }
                                        toolTip.css('display', 'none');
                                        if (TIMER != null) {
                                            window.clearTimeout(TIMER);
                                        }
                                    }).click(function () {
                                        button.addClass('js_memo').trigger(options.event_memorize_product).find('img').attr('src', options.btn_img_memo_active);
                                        setTooltipGfx(button, options.btn_img_tooltip_memoActive);
                                        if (button.parents().hasClass('quickviewLayer')) {
                                            qvL = button.parents('.quickviewLayer');
                                            if (qvL.data('caller') != null && qvL.data('caller') != undefined) {
                                                var product = qvL.data('caller');
                                                product.find(options.customerActions).find('.js_left').addClass('js_memo').css('display', 'block').find('img').attr('src', options.btn_img_memo_active);
                                            }
                                        } else {
                                            productWrap.data('memorized', true);
                                        }
                                    });
                                }
                            });
                        }
                        initCustomActions(btnMerken, productWrap);
                        var openQvLayer = function (pWrapper) {
                            var url = pWrapper.attr('data-url');
                            methods.closeQvLayer(options);
                            if (TIMER != null) {
                                window.clearTimeout(TIMER);
                            }
                            toolTip.css('display', 'none');
                            qvLayer.addClass('hidden');
                            qvDynamicContent.load(url, function () {
                                qvDC = $(this);
                                qvLayer.addClass(qvStyle);
                                qvLayer.data('caller', pWrapper);
                                var qvWidth = qvLayer.width();
                                var itemWidth = pWrapper.width();
                                var topPos = 64;
                                var leftPos = (qvWidth - itemWidth) / 2;
                                var dims = qvLayer.find('.js_dims');
                                wPos = pWrapper.position();
                                qvLayer.css({
                                    left: (wPos.left - leftPos),
                                    top: (wPos.top - topPos)
                                });
                                qvLayer.removeClass('hidden');
                                $('div#MainContent').css('overflow', 'visible');
                                qvLayer.find('.js_closeLayer').click(function () {
                                    methods.closeQvLayer(options);
                                });
                                qvDC.find(options.colSpotsWrap).mxColorSpot({
                                    control_right_img_on: options.control_right_img_on,
                                    control_right_img_off: options.control_right_img_off,
                                    control_left_img_on: options.control_left_img_on,
                                    control_left_img_off: options.control_left_img_off,
                                    slideTime: options.slideTime,
                                    MouseOverEvent: options.MouseOverEvent,
                                    MouseClickEvent: options.MouseClickEvent,
                                    TooltipEvent: options.TooltipEvent,
                                    sld_control_right_img_on: options.sld_control_right_img_on,
                                    sld_control_right_img_off: options.sld_control_right_img_off,
                                    sld_control_left_img_on: options.sld_control_left_img_on,
                                    sld_control_left_img_off: options.sld_control_left_img_off
                                });
                                initSlider(qvDC.find(options.colSpotsWrap), pWrapper.find(options.sliderInject).attr('sCount'));
                                qvDC.find(options.sizeSpotsWrap).mxSizeSpot({
                                    MouseOverEvent: options.size_MouseOverEvent,
                                    ClickEvent: options.size_ClickEvent,
                                    LeaveEvent: options.size_LeaveEvent
                                });
                                qvLayer.mouseleave(function () {
                                    $('body').click(function (event) {
                                        methods.closeQvLayer(options);
                                    });
                                });
                                qvLayer.click(function (event) {
                                    event.stopPropagation();
                                    $.noop();
                                });
                                qvLayer.find('.customerActions').css('display', 'block');
                                initCustomActions(qvLayer.find('.customerActions').find('.js_left'), pWrapper);
                                dims.find('a').unbind('mouseover');
                                dims.find('a').mouseover(function () {
                                    var link = $(this);
                                    if (link.parent('li').hasClass('deactivated') == false) {
                                        link.parents('.linkDims').find('.active').removeClass('active');
                                        link.parent('li').addClass('active');
                                        link.trigger(options.event_link_dim_active);
                                    }
                                    return false;
                                });
                            });
                            qvLayer.css('display', 'block');
                            if (options.customQvCallBack != undefined && options.customQvCallBack != null && $.type(options.customQvCallBack) == 'function') {
                                options.customQvCallBack();
                            }
                        }
                        var setTooltipGfx = function (objElement, iconSrc) {
                            var tmpImg = new Image();
                            tmpImg.src = iconSrc;
                            toolTip.find('img').attr('src', iconSrc);
                            var elmPos = objElement.offset();
                            var left = elmPos.left + objElement.width() - objElement.width();
                            var top = elmPos.top - toolTip.height();
                            toolTip.css({
                                left: left,
                                top: top
                            });
                            TIMER = window.setTimeout(function () {
                                $(options.tooltip).fadeIn(200);
                            }, options.showTooltip);
                        }
                        if (navigator.platform.indexOf('iPad') != -1) {
                            btnQuickview.click(function () {
                                setTooltipGfx($(this), options.btn_img_tooltip_detail);
                            }, function () {
                                toolTip.css('display', 'none');
                                if (TIMER != null) {
                                    window.clearTimeout(TIMER);
                                }
                                $(this).trigger(options.event_quickviewOpen);
                                openQvLayer(productWrap);
                            });
                        } else {
                            btnQuickview.hover(function () {
                                setTooltipGfx($(this), options.btn_img_tooltip_detail);
                            }, function () {
                                toolTip.css('display', 'none');
                                if (TIMER != null) {
                                    window.clearTimeout(TIMER);
                                }
                            });
                            btnQuickview.click(function () {
                                $(this).trigger(options.event_quickviewOpen);
                                openQvLayer(productWrap);
                            });
                        }
                        var custAct = function (objElement) {
                            if ($('body').hasClass('mobile') == false || $('body').hasClass('mobile') == undefined) {
                                objElement.mouseenter(function () {
                                    customerActions.css('display', 'block');
                                    if (btnMerken.hasClass('js_memo') == false) {
                                        btnMerken.stop(true, true).fadeIn('fast');
                                    }
                                    btnQuickview.stop(true, true).fadeIn('fast');
                                });
                            } else {
                                customerActions.css('display', 'block');
                                btnMerken.css('display', 'block');
                                btnQuickview.css('display', 'block');
                            }
                            productWrap.mouseleave(function () {
                                if ($('body').hasClass('mobile') == false || $('body').hasClass('mobile') == undefined) {
                                    if (btnMerken.hasClass('js_memo') == false) {
                                        btnMerken.stop(true, true).fadeOut('fast');
                                    }
                                    btnQuickview.stop(true, true).fadeOut('fast');
                                }
                            });
                        }
                        custAct(sliderParent);
                        custAct(colSpotsWrap);
                        dims.find('a').mouseover(function () {
                            var link = $(this);
                            if (link.parent('li').hasClass('deactivated') == false) {
                                link.parents('.linkDims').find('.active').removeClass('active');
                                link.parent('li').addClass('active');
                                link.trigger(options.event_link_dim_active);
                            }
                            return false;
                        });
                    });
                    wrapper.trigger(options.event_init);
                });
            },
            closeQvLayer: function (options) {
                var qvLayer = $(options.qvLayer);
                var qvDynamicContent = qvLayer.find(options.qvDynamicContent);
                $('body').unbind('click');
                qvDynamicContent.children().unbind().remove();
                qvLayer.css('display', 'none', function () {
                    $('div#MainContent').css('overflow', 'hidden');
                });
            }
        };
        $.fn.mxProductlist = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist on jQuery.mxProductlist');
            }
        };
    })(jQuery);;;
if (window.jQuery)(function ($) {
        var defaults = {
            min: 0,
            max: 500,
            values: [0, 500],
            text: 'Preis rub',
            minInpName: 'price_from',
            maxInpName: 'price_to',
            reduceBoxName: 'only_reduced_articles',
            reduceBoxText: 'Nur reduzierte Artikel',
            resetButtonText: 'Filter zurücksetzen',
            submitEvent: 'priceSliderSubmit',
            inputState: false,
            initReset: false,
            submitCB: function () {
                $.noop();
            }
        };
        var globals = {
            values: [],
            inputState: 'unchecked',
            lastTarget: null
        };
        var reg = new Array();
        var methods = {
            init: function (options) {
                return this.each(function () {
                    var o = $.extend({}, defaults, options);
                    var aktObj = $(this);
                    var $parent = aktObj.parents('div.priRaWrap');
                    var $minInp = $parent.find('input.priRaMinInp');
                    var $inpSep = $parent.find('input.priRaMaxInp');
                    var $maxInp = $parent.find('input.priRaMaxInp');
                    var $submitBtn = $parent.find('div.priRaSubmit');
                    var $resetBtn = $parent.find('div.js_reset');
                    var $priceText = $parent.find('span.prtext');
                    var $hideWrap = $parent.find('div.js_fscontent');
                    var $reducedHTML = $parent.find('div.js_reducedArticles');
                    var aktObjEvents = aktObj.data('events');
                    var allowedKeys = new Array(13, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105);
                    var controlKeys = new Array(8, 9, 37, 38, 39, 40, 46);
                    var rexe = /^\s*\d+\s*$/;
                    reg.push(aktObj);
                    $minInp.attr('name', o.minInpName).val((o.values[0] != undefined ? o.values[0] : o.min));
                    $maxInp.attr('name', o.maxInpName).val((o.values[1] != undefined ? o.values[1] : o.max));
                    $priceText.parent().get(0).innerHTML = o.text;
                    $resetBtn.attr('title', o.resetButtonText);
                    if (o.initReset == true) {
                        $resetBtn.removeClass('hide');
                    } else {
                        $resetBtn.addClass('hide');
                    }
                    if ($reducedHTML.length > 0) {
                        $reducedHTML.find('span').get(0).innerHTML = o.reduceBoxText;
                        $reducedHTML.find('input').attr('name', o.reduceBoxName);
                        if (o.inputState == true) {
                            $reducedHTML.find('input').attr('checked', "");
                        } else {
                            $reducedHTML.find('input').removeAttr('checked');
                        }
                    }
                    if (o.min != undefined) {
                        methods.set('min', o.min);
                    }
                    if (o.max != undefined) {
                        methods.set('max', o.max);
                    }
                    if (aktObj.parents('#filterInnerWrap').length > 0) {
                        aktObj.data('topfilter', true);
                    } else {
                        aktObj.data('topfilter', false);
                    }
                    if ((aktObjEvents == undefined || aktObjEvents == null) || (aktObjEvents['changeme'] == undefined || aktObjEvents['changeme'] == null)) {
                        aktObj.on('changeme', function () {
                            methods.updateSliders(aktObj);
                        });
                    }
                    var isAllowedkey = function (e, inputfield) {
                        if (e.shiftKey == true) {
                            return false;
                        } else {
                            if ($.inArray(e.which, allowedKeys) == -1 && $.inArray(e.which, controlKeys) == -1) {
                                return false;
                            } else {
                                var newInput = '';
                                var numblock = new Array();
                                numblock[96] = 0;
                                numblock[97] = 1;
                                numblock[98] = 2;
                                numblock[99] = 3;
                                numblock[100] = 4;
                                numblock[101] = 5;
                                numblock[102] = 6;
                                numblock[103] = 7;
                                numblock[104] = 8;
                                numblock[105] = 9;
                                if (numblock[e.which] != undefined) {
                                    newInput = numblock[e.which];
                                } else {
                                    if ($.inArray(e.which, controlKeys) != -1) {
                                        newInput = '';
                                    } else {
                                        newInput = String.fromCharCode(e.keyCode);
                                    }
                                }
                                return rexe.test($.trim(inputfield.val()) + newInput);
                            }
                        }
                    };
                    var checkInputs = function (jqObj, event) {
                        if (jqObj.hasClass('priRaMinInp')) {
                            if (jqObj.val() < o.min || jqObj.val() > o.max) {
                                if (jqObj.val() < o.min || jqObj.val() > o.max) {
                                    jqObj.val(o.min);
                                }
                            }
                        } else {
                            if (jqObj.val() < o.min || jqObj.val() > o.max) {
                                jqObj.val(o.max);
                            }
                        }
                    };
                    var closeToggle = function () {
                        var objToggle = $parent.find('.js_prtoggle');
                        var objContent = $parent.find('.js_fscontent');
                        var objArrow = objToggle.children('a.toggle');
                        if (objContent.hasClass('hide')) {
                            objContent.removeClass('hide');
                            objArrow.removeClass('up');
                            objArrow.addClass('down');
                        } else {
                            objContent.addClass('hide');
                            objArrow.removeClass('down');
                            objArrow.addClass('up');
                        }
                    };
                    $minInp.keydown(function (e) {
                        return isAllowedkey(e, $minInp);
                    });
                    $maxInp.keydown(function (e) {
                        return isAllowedkey(e, $maxInp);
                    });
                    $submitBtn.click(function () {
                        checkInputs($minInp);
                        checkInputs($maxInp);
                        globals.values = [$minInp.val(), $maxInp.val()];
                        if ($.isFunction(o.submitCB)) {
                            o.submitCB(globals.values);
                        }
                        $(this).parents('.fs_element').trigger(o.submitEvent, [globals.values]);
                        aktObj.trigger('priceRangeFireAjax');
                    });
                    $minInp.blur(function (e) {
                        var inp = $(this);
                        if (parseInt(inp.val()) <= parseInt($maxInp.val())) {
                            aktObj.slider("values", 0, inp.val());
                            globals.values[0] = inp.val();
                        } else {
                            inp.val(parseInt($maxInp.val()));
                            globals.values[1] = parseInt(inp.val());
                            aktObj.slider("values", 0, inp.val());
                        }
                        aktObj.trigger('changeme');
                    });
                    $maxInp.blur(function (e) {
                        var inp = $(this);
                        if (parseInt(inp.val()) >= parseInt($minInp.val())) {
                            aktObj.slider("values", 1, parseInt(inp.val()));
                            globals.values[1] = parseInt(inp.val());
                        } else {
                            inp.val(parseInt($minInp.val()));
                            globals.values[1] = parseInt(inp.val());
                            aktObj.slider("values", 1, parseInt(inp.val()));
                        }
                        aktObj.trigger('changeme');
                    });
                    $minInp.keyup(function (e) {
                        var inp = $(this);
                        if (parseInt(inp.val()) < parseInt($maxInp.val())) {
                            if (parseInt(inp.val()) >= o.min) {
                                aktObj.slider("values", 0, inp.val());
                                globals.values[0] = inp.val();
                                aktObj.trigger('changeme');
                            }
                        }
                        if (e.which == 13) {
                            checkInputs($minInp);
                            aktObj.trigger('changeme');
                            aktObj.trigger('priceRangeFireAjax');
                        }
                    });
                    $maxInp.keyup(function (e) {
                        var inp = $(this);
                        if (parseInt(inp.val()) > parseInt($minInp.val())) {
                            if (parseInt(inp.val()) <= o.max) {
                                aktObj.slider("values", 1, parseInt(inp.val()));
                                globals.values[1] = parseInt(inp.val());
                                aktObj.trigger('changeme');
                            }
                        }
                        if (e.which == 13) {
                            checkInputs($maxInp);
                            aktObj.trigger('changeme');
                            aktObj.trigger('priceRangeFireAjax');
                        }
                    });
                    if (aktObj.data('topfilter') == false) {
                        if ($reducedHTML.length > 0) {
                            if (o.inputState === true) {
                                globals.inputState = 'checked';
                            } else {
                                globals.inputState = 'unchecked';
                            }
                            $reducedHTML.find('span').click(function () {
                                var input = $(this).siblings('input');
                                if (input.prop('checked') == true) {
                                    input.prop('checked', false);
                                    input.trigger('change');
                                } else {
                                    input.prop('checked', true);
                                    input.trigger('change');
                                }
                            });
                            $reducedHTML.find('input').change(function () {
                                var input = $(this);
                                var filter = input.parents('div.fs_element');
                                if (input.prop('checked') == true) {
                                    $resetBtn.removeClass('hide');
                                    globals.inputState = 'checked';
                                } else {
                                    $resetBtn.addClass('hide');
                                    globals.inputState = 'unchecked';
                                }
                                methods.checkFilters(filter);
                                aktObj.trigger('priceRangeFireAjax');
                            });
                        }
                    }
                    $parent.css('display', 'block');
                    aktObj.on('priceRangeFireAjax', function () {
                        globals.lastTarget = aktObj;
                        $(document).trigger('FilterUpdateDone', [globals]);
                    })
                    aktObj.slider({
                        range: true,
                        min: o.min,
                        max: o.max,
                        values: o.values,
                        slide: function (event, ui) {
                            $minInp.val(ui.values[0]);
                            $maxInp.val(ui.values[1]);
                            $resetBtn.removeClass('hide');
                            aktObj.trigger('changeme');
                        },
                        change: function (event, ui) {
                            $minInp.val(ui.values[0]);
                            $maxInp.val(ui.values[1]);
                            $resetBtn.removeClass('hide');
                        },
                        stop: function (event, ui) {
                            globals.values = [ui.values[0], ui.values[1]];
                            $resetBtn.removeClass('hide');
                            aktObj.trigger('changeme');
                            aktObj.trigger('priceRangeFireAjax');
                        }
                    });
                    globals.values = o.values;
                    $resetBtn.click(function () {
                        methods.reset(aktObj);
                        $('div.priRaClose.js_reset').addClass('hide');
                    });
                    $parent.children('.js_prtoggle').click(function () {
                        closeToggle();
                    });
                });
            },
            checkForChanges: function () {
                var boolChangedValues = false;
                if (globals.values[0] != defaults.min) {
                    boolChangedValues = true;
                }
                if (boolChangedValues == false && globals.values[1] != defaults.max) {
                    boolChangedValues = true;
                }
                if ($('.js_reducedArticles').find('input').prop('checked') == true) {
                    boolChangedValues = true;
                }
                if (boolChangedValues == true) {
                    $('.fs_reset').removeClass('inactive').addClass('active');
                }
                return boolChangedValues;
            },
            updateSliders: function (obj) {
                for (var i = 0; i < reg.length; i++) {
                    if (reg[i] != obj) {
                        reg[i].slider("values", 0, globals.values[0]);
                        reg[i].slider("values", 1, globals.values[1]);
                    }
                }
                methods.checkForChanges();
            },
            reset: function (aktObj) {
                globals.values = [methods.get('min'), methods.get('max')];
                aktObj.slider("values", 0, methods.get('min'));
                aktObj.slider("values", 1, methods.get('max'));
                aktObj.trigger('changeme');
                globals = {
                    values: [],
                    inputState: 'unchecked',
                    lastTarget: null
                };
                for (var i = 0; i < reg.length; i++) {
                    reg[i].parents('.priRaWrap').find('.js_reset').addClass('hide');
                    reg[i].siblings('.js_reducedArticles').find('input').prop('checked', false);
                }
                methods.checkFilters(aktObj.parents('.fs_element'));
                aktObj.trigger('priceRangeFireAjax');
            },
            prepareForUpdate: function () {
                globals = {
                    values: [],
                    inputState: 'unchecked',
                    lastTarget: null
                };
                reg = new Array();
            },
            checkFilters: function (filter) {
                var collects = filter.sidebarFilter('getCollection');
                var boolChangedValues = false;
                var colCount = 0;
                for (e in collects) {
                    colCount += filter.sidebarFilter('getSize', collects[e]);
                }
                if (colCount == 0) {
                    if (globals.values[0] != defaults.min) {
                        boolChangedValues = true;
                    }
                    if (boolChangedValues == false && globals.values[1] != defaults.max) {
                        boolChangedValues = true;
                    }
                    if ($('.js_reducedArticles').find('input').prop('checked') == true) {
                        boolChangedValues = true;
                    }
                    if (boolChangedValues == true) {
                        $('.fs_reset').removeClass('inactive').addClass('active');
                    } else {
                        $('.fs_reset').removeClass('active').addClass('inactive');
                    }
                } else {
                    $('.fs_reset').removeClass('inactive').addClass('active');
                }
            },
            setSliderValues: function (val_1, val_2) {
                globals.values = [val_1, val_2];
            },
            getGlobals: function () {
                return globals;
            },
            get: function (key) {
                return defaults[key];
            },
            set: function (key, value) {
                defaults[key] = value;
            }
        };
        $.fn.priceRange = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist!');
            }
        };
    })(jQuery);;;
if (window.jQuery)(function ($) {
        var plugincountCalls = 0;
        var defaults = {
            upDateDoneTimeout: 500,
            upDateDoneTimer: TimeSettings['filterUpdateDone']
        };
        var globCollection = {};
        var reg = [];
        var locked = [];
        var spotFilters = ['sizeNormal', 'colorPicker'];
        var allCustomScrollbars = null;

        function reduceFilterWhitespace(aktObj) {}

        function addCollection(collectionScope, name) {
            var collection = null;
            if (collectionScope[name] == undefined || collectionScope[name] == null) {
                collectionScope[name] = {};
                collection = collectionScope[name];
            } else {
                collection = collectionScope[name];
            }
            return collection;
        }

        function checkCollection(obj, collection) {
            if (obj.data('name') != 'priceRange') {
                scrollCondition(obj);
                var size = methods.getSize(collection);
                if (obj.data('topfilter') == true) {
                    var filID = obj.attr('id');
                    var olayBase = $('#L' + filID);
                    var objCollectWrap = olayBase.find('.js_fssearchcollect');
                }
                if (size > 0) {
                    obj.find('.js_fssearchcollect').removeClass('hide');
                    if (obj.data('topfilter') == true) {
                        objCollectWrap.removeClass('hide');
                        var filterActionLink = obj.data('filterActionLink');
                        if (filterActionLink != undefined) {
                            filterActionLink.html(filterActionLink.data('notEmpty'));
                        }
                    } else {
                        obj.find('.js_reset').addClass('show').removeClass('hide');
                    }
                } else {
                    obj.find('.js_fssearchcollect').addClass('hide');
                    if (obj.data('topfilter') == true) {
                        objCollectWrap.addClass('hide');
                        if (obj.data('filterActionLink') != undefined) {
                            var filterActionLink = obj.data('filterActionLink');
                            filterActionLink.html(filterActionLink.data('empty'));
                        }
                    } else {
                        obj.find('.js_reset').removeClass('show').addClass('hide');
                    }
                }
                return size;
            }
        }

        function collectionPush(li, collection) {
            var suggest = li.attr('suggest');
            var amount = li.attr('amount');
            var display = li.attr('display');
            collection[suggest] = {};
            collection[suggest].suggest = suggest;
            collection[suggest].amount = amount;
            collection[suggest].display = display;
            return true;
        }

        function collectionKill(li, collection) {
            var suggest = li.attr('suggest');
            if (collection[suggest] != undefined) {
                delete(collection[suggest]);
                return true;
            }
            return false;
        }

        function sortList(list, sortstyle) {
            var sortMe = [];
            var listChildren = list.children('li');
            var stringfound = false;
            var mapping
            for (var i = 0; i < listChildren.length; i++) {
                var suggest = $(listChildren[i]).attr('suggest');
                if (isNaN(suggest)) {
                    stringfound = true;
                }
                sortMe.push(suggest);
            }
            if (stringfound === true) {
                sortMe = sortMe.sort(function (a, b) {
                    return a.toLowerCase().localeCompare(b.toLowerCase());
                });
            } else {
                sortMe = sortMe.sort(function (a, b) {
                    return parseInt(a) - parseInt(b);
                });
            }
            for (var i = 0; i < sortMe.length; i++) {
                list.append(list.find('li[suggest="' + sortMe[i] + '"]'));
            }
        }

        function glossClick(obj) {
            obj.click(function (e) {
                e.preventDefault();
                e.stopPropagation();
                return false;
            });
            return false;
        }

        function toggleSelected(li) {
            if (li.hasClass('checked selected')) {
                li.removeClass('checked selected').find('input').prop('checked', false);
            } else {
                li.addClass('checked selected').find('input').prop('checked', true);
            }
        }

        function toggleHiding(li) {
            if (li.hasClass('hide')) {
                li.removeClass('hide').find('input').prop('checked', false);
            } else {
                li.addClass('hide').find('input').prop('checked', true);
            }
        }

        function scrollCondition(aktObj, fromEvent) {
            var scrollApi = aktObj.find('.js_scrollBar').data('jsp');
            if (aktObj.data('topfilter') == false) {
                var entry = aktObj.find('.js_fssearchresult')
                var allLiHeight = 0;
                var entryLi = entry.find('li');
                for (var i = 0; i < entryLi.length; i++) {
                    if (fromEvent == undefined) {
                        if ($(entryLi[i]).hasClass('hide') == false) {
                            allLiHeight += $(entryLi[i]).outerHeight(true);
                        }
                    } else {
                        if ($(entryLi[i]).hasClass('hideSuggest') == false) {
                            allLiHeight += $(entryLi[i]).outerHeight(true);
                        }
                    }
                }
                if (allLiHeight > entry.height()) {
                    aktObj.addClass('scroll');
                } else {
                    aktObj.removeClass('scroll');
                }
            }
            if (scrollApi != undefined) {
                scrollApi.reinitialise();
            }
        }

        function showCollection(collectList, html, aktObj, preventPush) {
            collection = globCollection[aktObj.data('name')];
            collectList.children().remove();
            if (collectList.get(0) != undefined) {
                collectList.get(0).innerHTML = html;
                glossClick(collectList.find('.js_glossary'));
                sortList(collectList, 'numeric');
                collectList.children('li').click(function () {
                    var thisLi = $(this);
                    var suggest = thisLi.attr('suggest');
                    var resultList = aktObj.data('resultDOM');
                    if (preventPush === true) {
                        resultList.find('li.js_result[suggest="' + suggest + '"]').removeClass('hide').find('input').prop('checked', false);
                    } else {
                        collectionKill(thisLi, globCollection[aktObj.data('name')]);
                        aktObj.trigger('updateFromCollection', [globCollection[aktObj.data('name')]]);
                    }
                    thisLi.remove();
                    if (preventPush === true) {
                        if (collectList.children('li').length == 0) {
                            collectList.parent().addClass('hide');
                        } else {
                            collectList.parent().removeClass('hide');
                        }
                    }
                    reinitScrollbars(aktObj.data('resultDOM').parents('.js_scrollBar'));
                });
            }
        }

        function prePareTopHTML(li, aktObj) {
            var $newLiHolder = $('<div></div>');
            var filID = aktObj.attr('id');
            var olayBase = $('#L' + filID);
            var overLayResult = olayBase.find('.js_resultlist');
            var objCollectList = aktObj.siblings('.js_fssearchcollect').find('ul.js_collectlist');
            var objCollectListOverlay = olayBase.find('.js_fssearchcollect').find('ul.js_collectlist');
            var $newLiHTML;
            objCollectListOverlay.parents('.js_fssearchcollect').removeClass('hide');
            $newLiHTML = '<li class="js_collect" display="' + li.attr('display') + '" suggest="' + li.attr('suggest') + '" amount="' + li.attr('amount') + '">' + '<input type="checkbox" name="" class="Checkbox js_fsfilVal" checked value="">' + '<div class="filVal js_fsfilVal">' + '<span> ' + li.attr('display') + ' </span>' + '<span class="filAmount">(' + li.attr('amount') + ')</span>' + '</div>' + '</li>';
            $newLiHolder.append($newLiHTML);
            li.addClass('hide selected');
            objCollectListOverlay.append($newLiHolder.html()).find('li[suggest="' + li.attr('suggest') + '"]').click(function () {
                var thisLi = $(this);
                var suggest = thisLi.attr('suggest');
                var filterActionLink = null;
                if (aktObj.data('filterActionLink') != undefined) {
                    filterActionLink = aktObj.data('filterActionLink');
                }
                overLayResult.find('li.js_result[suggest="' + suggest + '"]').removeClass('hide selected').find('input').prop('checked', false);
                thisLi.remove();
                if (objCollectListOverlay.find('li').length == 0) {
                    objCollectListOverlay.parents('.js_fssearchcollect').addClass('hide');
                }
                if (filterActionLink != null) {
                    if (objCollectListOverlay.find('li').length > 0) {
                        filterActionLink.html(filterActionLink.data('notEmpty'));
                    } else {
                        filterActionLink.html(filterActionLink.data('empty'));
                    }
                }
                reinitScrollbars(aktObj.data('resultDOM').parents('.js_scrollBar'));
            });
            reinitScrollbars(aktObj.data('resultDOM').parents('.js_scrollBar'));
            sortList(objCollectListOverlay);
        }

        function multiHTML(aktObj, position) {
            objName = aktObj.data('name');
            resultList = aktObj.data('resultDOM');
            resultList.find('li.hide').removeClass('hide selected').find('input').prop('checked', false);
            var collection = globCollection[objName];
            var $newLiHolder = $('<div></div>');
            for (e in collection) {
                var glossary = null;
                var thisLi = $('li.js_result[suggest="' + collection[e].suggest + '"]');
                thisLi.addClass('hide selected');
                if (position == 'left') {
                    var tmpGlossary = thisLi.find('.js_glossary');
                    if (tmpGlossary.length > 0) {
                        glossary = tmpGlossary;
                    }
                }
                $newLiHTML = $('<li class="js_collect" display="' + collection[e].display + '" suggest="' + collection[e].suggest + '" amount="' + collection[e].amount + '">' + '<input type="checkbox" name="" class="Checkbox js_fsfilVal" checked value="">' + '<div class="filVal js_fsfilVal">' + '<span> ' + collection[e].display + ' </span>' + '<span class="filAmount">(' + collection[e].amount + ')</span>' + '</div>' +
                    ((glossary !== null && glossary.length > 0) ? '<a href="javascript: void(0);" rel="" class="glossOpen js_glossary"></a>' : '') + '</li>');
                $newLiHolder.append($newLiHTML);
                if (glossary !== null) {
                    $newLiHTML.addClass('js_glossar').css({
                        position: 'relative',
                        'z-index': 100
                    });
                    var clone = $newLiHTML.find('.js_glossary');
                    clone.attr('onclick', glossary.attr('onclick'));
                }
            }
            if (position == 'top') {
                var filID = aktObj.attr('id');
                var olayBase = $('#L' + filID);
                var overLayResult = olayBase.find('.js_resultlist');
                var objCollectList = aktObj.siblings('.js_fssearchcollect').find('ul.js_collectlist');
                var objCollectListOverlay = olayBase.find('.js_fssearchcollect').find('ul.js_collectlist');
            } else {
                var objCollectList = aktObj.find('ul.js_collectlist');
            }
            showCollection(objCollectList, $newLiHolder.html(), aktObj);
            sortList(objCollectList);
            if (objCollectListOverlay != undefined) {
                showCollection(objCollectListOverlay, $newLiHolder.html(), aktObj, true);
                sortList(objCollectListOverlay);
            }
        }

        function writeSpotHtml(aktObj, position) {
            objName = aktObj.data('name');
            resultList = aktObj.data('resultDOM');
            resultList.find('li.selected').removeClass('checked selected').find('input').prop('checked', false);
            var collection = globCollection[objName];
            var $newLiHTML = '';
            for (e in collection) {
                if (position == 'left' || objName == 'colorPicker' || objName == 'sizeNormal') {
                    $('li.js_result[suggest="' + collection[e].suggest + '"]').addClass('checked selected').find('input').prop('checked', true);
                }
                if (objName == 'colorPicker') {
                    $newLiHTML += '<li amount="' + collection[e].amount + '" display="' + collection[e].display + '" suggest="' + collection[e].suggest + '" class="js_collect">' + '<div class="filColImg">' + '<div class="' + collection[e].display + '">' + '<a href="javascript:void(0);"></a>' + '</div>' + '</div>' + '</li>';
                } else {
                    $newLiHTML += '<li class="js_collect" display="' + collection[e].display + '" suggest="' + collection[e].suggest + '" amount="' + collection[e].amount + '">' + '<input type="checkbox" name="groesse[]" class="Checkbox js_fsfilVal" checked="" value="' + collection[e].suggest + '">' + '<div class="js_fsfilVal">' + '<span> ' + collection[e].display + ' </span>' + '</div>' + '</li>';
                }
            }
            if (position == 'top') {
                var filID = aktObj.attr('id');
                var olayBase = $('#L' + filID);
                var overLayResult = olayBase.find('.js_resultlist');
                var objCollectList = aktObj.siblings('.js_fssearchcollect').find('ul.js_collectlist');
                objCollectList.children().remove();
                if (objCollectList.get(0) != undefined) {
                    objCollectList.get(0).innerHTML = $newLiHTML;
                }
                switch (objName) {
                    case 'sizeNormal':
                        sortList(objCollectList, 'numeric');
                        break;
                    default:
                        sortList(objCollectList);
                        break;
                }
                objCollectList.children('li').click(function () {
                    var thisLi = $(this);
                    var collection = globCollection[aktObj.data('name')];
                    if (locked[aktObj.data('name')] != undefined) {
                        delete(locked[aktObj.data('name')]);
                    }
                    if (collection[thisLi.attr('suggest')] != undefined) {
                        delete(collection[thisLi.attr('suggest')]);
                    }
                    thisLi.remove();
                    aktObj.trigger('updateFromCollection');
                });
            }
        }

        function reinitScrollbars(obj) {
            var scrollApi = obj.data('jsp');
            if (scrollApi != undefined) {
                scrollApi.reinitialise();
            }
        }
        var methods = {
            init: function (options) {
                $('#filterInnerWrap .fs_reset, #LeftNavigation .fs_reset').click(function () {
                    if ($(this).hasClass('inactive')) {
                        return false;
                    } else {
                        methods.reset();
                    }
                });
                glossClick($('#filterMasterLayer .js_glossary, #LeftNavigation .js_glossary'));
                allCustomScrollbars = $('#filterMasterLayer .js_scrollBar, #LeftNavigation .js_scrollBar');
                if ($('body').hasClass('ie8') == false && $('body').hasClass('ie7') == false) {
                    for (var i = 0; i < allCustomScrollbars.length; i++) {
                        $(allCustomScrollbars[i]).jScrollPane({
                            showArrows: true,
                            animateScroll: true,
                            animateDuration: 200,
                            arrowButtonSpeed: 35
                        });
                    }
                } else {
                    for (var i = 0; i < allCustomScrollbars.length; i++) {
                        $(allCustomScrollbars[i]).css({
                            'overflow-x': 'hidden',
                            'overflow-y': 'auto'
                        });
                    }
                }
                var thisElements = this;
                for (var i = 0; i < thisElements.length; i++) {
                    (function (jqObject) {
                        var o = $.extend({}, defaults, options);
                        var aktObj = $(jqObject);
                        var objDataName = aktObj.attr('data-name');
                        var pluginElmCount = $(document).find('.fs_element').length;
                        var resetBtn = aktObj.find('.js_reset');
                        var filterActionLink = null;
                        var allCollectionCount = 0;
                        var tmpCollection = {};
                        var scrollable = aktObj.find('.js_scrollBar');
                        var objSelected;
                        var objResultList;
                        var objCollectList;
                        var objLis;
                        var collection;
                        var submitLink;
                        reg.push(aktObj);
                        collection = addCollection(globCollection, objDataName);
                        resetBtn.click(function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            methods.reset(aktObj);
                        });
                        if (aktObj.parents('#filterInnerWrap').length > 0) {
                            aktObj.data('topfilter', true);
                            var overLayFilter = $('#L' + aktObj.attr('id'));
                            objResultList = overLayFilter.find('.js_resultlist');
                            objCollectList = overLayFilter.find('.js_collectlist');
                            submitLink = overLayFilter.find('a.submit');
                            if (overLayFilter.find('.filSelAct a').length > 0) {
                                filterActionLink = overLayFilter.find('.filSelAct a');
                                aktObj.data('filterActionLink', filterActionLink);
                            }
                        } else {
                            aktObj.data('topfilter', false);
                            objResultList = aktObj.find('.js_resultlist');
                            objCollectList = aktObj.find('.js_collectlist');
                        }
                        aktObj.data('resultDOM', objResultList);
                        aktObj.data('collectDOM', objCollectList);
                        objLis = objResultList.find('li.js_result');
                        objSelected = objResultList.find('li.selected');
                        if (aktObj.data('topfilter') == true) {
                            if ($.inArray(objDataName, spotFilters) != -1) {
                                if ($('body').hasClass('mobile') == false) {
                                    objLis.hover(function () {
                                        var thisLi = $(this);
                                        thisLi.addClass('active');
                                    }, function () {
                                        var thisLi = $(this);
                                        thisLi.removeClass('active');
                                    });
                                }
                                objLis.click(function () {
                                    var thisLi = $(this);
                                    if (thisLi.hasClass('deactivated')) {
                                        return false;
                                    }
                                    toggleSelected(thisLi);
                                    if (filterActionLink != null) {
                                        if (objResultList.find('li.selected').length > 0) {
                                            filterActionLink.html(rels[0]);
                                        } else {
                                            filterActionLink.html(rels[1]);
                                        }
                                    }
                                });
                            } else {
                                objLis.click(function () {
                                    var thisLi = $(this);
                                    if (thisLi.hasClass('deactivated')) {
                                        return false;
                                    }
                                    toggleSelected(thisLi);
                                    toggleHiding(thisLi);
                                    prePareTopHTML(thisLi, aktObj);
                                    if (filterActionLink != null) {
                                        if (objCollectList.find('li').length > 0) {
                                            filterActionLink.html(rels[0]);
                                        } else {
                                            filterActionLink.html(rels[1]);
                                        }
                                    }
                                });
                            }
                            submitLink.click(function () {
                                for (e in collection) {
                                    delete(collection[e]);
                                }
                                if ($.inArray(objDataName, spotFilters) != -1) {
                                    var selLis = objResultList.find('li.selected');
                                    for (var i = 0; i < selLis.length; i++) {
                                        collectionPush($(selLis[i]), collection);
                                    }
                                } else {
                                    var selLis = objResultList.find('li.hide');
                                    for (var i = 0; i < selLis.length; i++) {
                                        collectionPush($(selLis[i]), collection);
                                    }
                                }
                                aktObj.trigger('updateFromCollection', [collection]);
                                GeneralJS.HideFilter($('#filterOverlay'));
                            });
                        } else {
                            if ($.inArray(objDataName, spotFilters) != -1) {
                                for (var i = 0; i < objSelected.length; i++) {
                                    collectionPush($(objSelected[i]), collection);
                                }
                                if ($('body').hasClass('mobile') == false) {
                                    objLis.hover(function () {
                                        var thisLi = $(this);
                                        if (thisLi.hasClass('deactivated')) {
                                            return false;
                                        }
                                        thisLi.addClass('active');
                                    }, function () {
                                        var thisLi = $(this);
                                        thisLi.removeClass('active');
                                    });
                                }
                                objLis.click(function () {
                                    var thisLi = $(this);
                                    if (thisLi.hasClass('deactivated')) {
                                        return false;
                                    }
                                    toggleSelected(thisLi);
                                    if (thisLi.hasClass('selected')) {
                                        collectionPush(thisLi, collection);
                                    } else {
                                        collectionKill(thisLi, collection);
                                    }
                                    aktObj.trigger('updateFromCollection', [collection]);
                                });
                            } else {
                                var collectlistLi = objCollectList.children('li');
                                for (var i = 0; i < collectlistLi.length; i++) {
                                    collectionPush($(collectlistLi[i]), collection);
                                }
                                objLis.click(function () {
                                    if (filterActionLink != null) {
                                        if (methods.getSize(collection) > 0) {
                                            filterActionLink.html(rels[0]);
                                        } else {
                                            filterActionLink.html(rels[1]);
                                        }
                                    }
                                    var thisLi = $(this);
                                    if (thisLi.hasClass('deactivated')) {
                                        return false;
                                    }
                                    toggleSelected(thisLi);
                                    if (thisLi.hasClass('selected')) {
                                        collectionPush(thisLi, collection);
                                        thisLi.addClass('hide');
                                    } else {
                                        collectionKill(thisLi, collection);
                                        thisLi.removeClass('hide');
                                    }
                                    reinitScrollbars(aktObj.data('resultDOM').parents('.js_scrollBar'));
                                    aktObj.trigger('updateFromCollection', [collection]);
                                });
                            }
                        }
                        aktObj.on('updateFromCollection', function (event, data) {
                            if (o.upDateDoneTimer != undefined) {
                                clearTimeout(o.upDateDoneTimer);
                            }
                            for (var i = 0; i < reg.length; i++) {
                                var objDataName = reg[i].data('name');
                                var position = 'left';
                                var resetBtn = reg[i].find('.js_reset');
                                if (reg[i].data('topfilter') == true) {
                                    position = 'top';
                                }
                                if ($.inArray(objDataName, spotFilters) != -1) {
                                    writeSpotHtml(reg[i], position);
                                } else {
                                    multiHTML(reg[i], position);
                                }
                                if (objDataName != 'priceRange') {
                                    allCollectionCount += checkCollection(reg[i], globCollection[objDataName]);
                                }
                                if (methods.getSize(globCollection[objDataName]) > 0) {
                                    resetBtn.addClass('show');
                                } else {
                                    resetBtn.removeClass('show');
                                }
                                if (allCollectionCount > 0) {
                                    $('.fs_reset').addClass('active').removeClass('inactive');
                                } else {
                                    $('.fs_reset').addClass('inactive').removeClass('active');
                                }
                            }
                            allCollectionCount = 0;
                            reinitScrollbars(aktObj.data('resultDOM').parents('.js_scrollBar'));
                            o.upDateDoneTimer = window.setTimeout(function () {
                                $(document).trigger('FilterUpdateDone', [methods.getCollection()]);
                            }, o.upDateDoneTimeout);
                        });
                        aktObj.on('filtersuggestKeyup', function () {
                            scrollCondition(aktObj, true);
                        });
                        if (filterActionLink !== null) {
                            var rel = filterActionLink.attr('rel');
                            var rels = rel.split('|');
                            var text = filterActionLink.html();
                            filterActionLink.data({
                                'notEmpty': rels[0],
                                'empty': rels[1]
                            });
                            if (methods.getSize(collection) > 0) {
                                filterActionLink.html(rels[0]);
                            } else {
                                filterActionLink.html(rels[1]);
                            }
                            filterActionLink.one(function () {
                                $(this).unbind();
                            });
                            if ($.inArray(objDataName, spotFilters) != -1) {
                                filterActionLink.click(function () {
                                    var selection = objResultList.find('li.selected');
                                    if (selection.length > 0) {
                                        for (var i = 0; i < selection.length; i++) {
                                            $(selection[i]).removeClass('checked selected').find('input').prop('checked', false);
                                        }
                                        $(this).html(rels[1]);
                                    } else {
                                        for (var i = 0; i < objLis.length; i++) {
                                            var thisLi = $(objLis[i]);
                                            if (thisLi.hasClass('deactivated') == false) {
                                                thisLi.addClass('checked selected').find('input').prop('checked', true);
                                            }
                                        }
                                        $(this).html(rels[0]);
                                    }
                                });
                            } else {
                                filterActionLink.click(function () {
                                    var link = $(this);
                                    var collectList = aktObj.data('collectDOM');
                                    var resultList = aktObj.data('resultDOM');
                                    if (collectList.children('li').length > 0) {
                                        collectList.empty();
                                        link.parents('.filContWrap').find('.js_fssearchcollect').addClass('hide').find('.Seperator').addClass('hide');
                                        var resListLi = resultList.children('li');
                                        for (var i = 0; i < resListLi.length; i++) {
                                            $(resListLi[i]).removeClass('checked selected hide').find('input').prop('checked', false);
                                        }
                                        $(this).html(rels[1]);
                                        var scrollers = link.parents('.filContWrap').find('.js_scrollBar');
                                        for (var i = 0; i < scrollers.length; i++) {
                                            var scrollApi = $(scrollers[i]).data('jsp');
                                            if (scrollApi != undefined) {
                                                scrollApi.reinitialise();
                                            }
                                        }
                                    } else {
                                        for (var i = 0; i < objLis.length; i++) {
                                            var thisLi = $(objLis[i]);
                                            if (thisLi.hasClass('deactivated') == false) {
                                                prePareTopHTML(thisLi, aktObj);
                                            }
                                        }
                                        link.parents('div.filContWrap').find('div.js_fssearchcollect').removeClass('hide').find('div.Seperator').removeClass('hide');
                                        $(this).html(rels[0]);
                                    }
                                });
                            }
                        }
                        plugincountCalls++;
                        if (plugincountCalls == pluginElmCount) {
                            aktObj.trigger('updateFromCollection');
                        }
                        return aktObj;
                    })(thisElements[i]);
                }
            },
            prepareForAjax: function () {
                plugincountCalls = 0;
                globCollection = {};
                reg = [];
            },
            getSize: function (obj) {
                var count = 0;
                for (e in obj) {
                    count++;
                }
                return parseInt(count);
            },
            getCollection: function (name) {
                var ret = globCollection;
                if (name != undefined || name != null) {
                    if (globCollection[name] != undefined && globCollection[name] != null) {
                        ret = globCollection[name];
                    }
                }
                return ret;
            },
            reset: function (filter, preventUpdate) {
                function deleteSection(filter) {
                    if (filter.data('name') == 'priceRange') {
                        filter.priceRange('reset', $('.rangeInput').first());
                        return true;
                    }
                    var filterActionLink = filter.data('filterActionLink');
                    var filInput = filter.find('.js_fsinput');
                    var searchCollectWrap = filter.find('.js_fssearchcollect');
                    collection = globCollection[filter.data('name')];
                    resultList = filter.data('resultDOM');
                    collectList = filter.data('collectDOM');
                    if (locked[filter.data('name')] != undefined) {
                        delete(locked[filter.data('name')]);
                    }
                    for (e in collection) {
                        $('li[suggest="' + e + '"]').removeClass('hide').removeClass('hideSuggest').removeClass('selected').find('input').prop('checked', false);
                        delete(collection[e]);
                    }
                    if (filInput.data('oldColor') != undefined) {
                        filInput.css('color', filInput.data('oldColor'));
                    }
                    if (filInput.data('oldText') != undefined) {
                        filInput.val(filInput.data('oldText'));
                    } else {
                        filInput.val('');
                    }
                    $('.js_filterSearch').filterSuggest('reset');
                    collectList.children().remove();
                    searchCollectWrap.addClass('hide');
                    filter.find('.js_reset').addClass('hide');
                    if (filterActionLink != undefined) {
                        filterActionLink.html(filterActionLink.data('empty'));
                    }
                }
                if (filter != undefined || filter != null) {
                    deleteSection(filter);
                    if (preventUpdate == undefined) {
                        filter.trigger('updateFromCollection');
                    }
                } else {
                    $(document).trigger('resetAllFilter');
                    for (var i = 0; i < reg.length; i++) {
                        deleteSection(reg[i]);
                        if (i == reg.length - 1) {
                            if (preventUpdate == undefined) {
                                reg[i].trigger('updateFromCollection');
                            }
                        }
                    }
                }
            },
            get: function (key) {
                return defaults[key];
            },
            set: function (key, value) {
                defaults[key] = value;
            }
        };
        $.fn.sidebarFilter = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist!');
            }
        };
    })(jQuery);;;
if (window.jQuery)(function ($) {
        var defaults = {
            searchField: '.js_searchinp',
            searchParent: '.js_searchParent'
        };
        var allCustomScrollbars = $('#filterMasterLayer .js_scrollBar, #LeftNavigation .js_scrollBar');

        function scrollbarReinit(scroller) {
            var scrollApi = scroller.data('jsp');
            if (scrollApi != undefined) {
                scrollApi.reinitialise();
            }
        }

        function sortList(list, sortstyle) {
            var sortMe = [];
            var listChildren = list.children('li');
            var stringfound = false;
            var mapping
            for (var i = 0; i < listChildren.length; i++) {
                var suggest = $(listChildren[i]).attr('suggest');
                if (isNaN(suggest)) {
                    stringfound = true;
                }
                sortMe.push(suggest);
            }
            if (stringfound === true) {
                sortMe = sortMe.sort(function (a, b) {
                    return a.toLowerCase().localeCompare(b.toLowerCase());
                });
            } else {
                sortMe = sortMe.sort(function (a, b) {
                    return parseInt(a) - parseInt(b);
                });
            }
            for (var i = 0; i < sortMe.length; i++) {
                list.append(list.find('li[suggest="' + sortMe[i] + '"]'));
            }
        }
        var methods = {
            init: function (options) {
                return this.each(function () {
                    var o = $.extend({}, defaults, options);
                    var aktObj = $(this);
                    var scroller = aktObj.find('div.js_scrollBar');
                    var input = aktObj.find(o.searchField);
                    var searchParent = aktObj.find(o.searchParent);
                    var docBody = $('body');
                    var filter = aktObj.parents('.fs_element');
                    input.parents('form').submit(function () {
                        return false;
                    });
                    input.blur(function () {
                        if ($.trim(input.val()) == '') {
                            input.css('color', input.data('oldColor'));
                            input.val(input.data('oldText'));
                        }
                    });
                    input.keyup(function () {
                        var val = input.val();
                        var filterObjects = searchParent.find('li.js_sIndex');
                        for (var i = 0; i < filterObjects.length; i++) {
                            var actFo = $(filterObjects[i]);
                            var brand = actFo.attr('display');
                            var part = brand.substr(0, val.length);
                            var textholder = actFo.find('span').first();
                            var text = textholder.html();
                            actFo.data('text', brand);
                            if (part.toLowerCase() != val.toLowerCase()) {
                                actFo.addClass('hideSuggest').find('input').attr('disabled', 'disabled');
                                if (textholder.get(0) != undefined) {
                                    textholder.get(0).innerHTML = actFo.data('text');
                                }
                            } else {
                                var fattext = brand.replace(part, '<b>' + part + '</b>');
                                actFo.data('fattext', fattext);
                                if (textholder.get(0) != undefined) {
                                    textholder.get(0).innerHTML = actFo.data('fattext');
                                }
                                actFo.removeClass('hideSuggest').find('input').removeAttr('disabled');
                            }
                        }
                        scrollbarReinit(scroller);
                        filter.trigger('filtersuggestKeyup');
                    });
                    input.focus(function () {
                        var inp = $(this);
                        if (inp.data('oldColor') == undefined && inp.data('oldText') == undefined) {
                            inp.data({
                                oldColor: inp.css('color'),
                                oldText: inp.val()
                            });
                        }
                        if ($.trim(inp.val()) == inp.data('oldText')) {
                            inp.val('');
                            inp.css('color', '#212121');
                        }
                    });
                });
            },
            reset: function () {
                var filterObjects = $('li.js_sIndex');
                for (var i = 0; i < filterObjects.length; i++) {
                    var thisLi = $(filterObjects[i]);
                    thisLi.removeClass('hideSuggest').find('input').removeAttr('disabled');
                    thisLi.find('span').first().html(thisLi.data('text'));
                };
                scrollbarReinit($('#filterMasterLayer .js_filterSearch, #LeftNavigation .js_filterSearch').find('div.js_scrollBar'));
            },
            get: function (key) {
                defaults[key];
            },
            set: function (key, value) {
                defaults[key] = value;
            }
        };
        $.fn.filterSuggest = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist!');
            }
        };
    })(jQuery);
$(document).ready(function () {
    $('#filterMasterLayer .js_filterSearch, #LeftNavigation .js_filterSearch').filterSuggest();
});;;
if (window.jQuery)(function ($) {
        var defaults = {
            ajaxUrl: '_public/suggestedSearchDummy.php',
            ajaxRequest: 'get',
            ajaxWait: 200,
            ajaxSuccessCallBack: function () {
                $.noop();
            },
            ajaxErrorCallBack: function () {
                $.noop();
            },
            selectCallBack: function () {
                $.noop();
            },
            minInput: 1,
            lastSearches: ['caprihose', 'Abendkleider', 'Knallfarben'],
            openDelay: 200,
            openTimeout: TimeSettings['ResWrapOpen'],
            closeTimeout: TimeSettings['ResWrapClose'],
            submitTimeout: TimeSettings['SsSubmit'],
            tabletTime: 500,
            requestTimeout: TimeSettings['ssAjRequest'],
            parent: '#sugWrap'
        };
        var reg = new Array();
        var methods = {
            init: function (options) {
                return this.each(function () {
                    var settings = $.extend({}, defaults, options);
                    var ssInpObj = $(this);
                    var o = settings;
                    var parent = ssInpObj.parents(o.parent);
                    var resultWrap = parent.find('.resWrap');
                    var resList = resultWrap.find('.js_results');
                    var seperator = resultWrap.find('.js_sugSep');
                    var lastList = resultWrap.find('.js_lastSearch');
                    var closeBtn = parent.find('.btnClose');
                    var form = parent.find('form');
                    var keyValues = new Array(9, 27, 13, 38, 40);
                    var lock = true;
                    var allEvents = $(document).data('events');
                    var o;
                    reg.push(ssInpObj);
                    ssInpObj.data({
                        lastSearch: o.lastSearches,
                        result: 'ergebnis',
                        lastInput: '',
                        sendtime: 0,
                        parent: parent
                    });
                    closeBtn.css('display', 'none');
                    var open = function () {
                        for (var i = 0; i < reg.length; i++) {
                            if (resultWrap.css('display') != 'block') {
                                if (reg[i].data('active') === true) {
                                    reg[i].data('parent').find('.btnClose').css('display', 'none');
                                    reg[i].data('parent').find('.resWrap').css('display', 'none');
                                    reg[i].data('parent').find('.js_active').css('display', 'none').removeClass('js_active');
                                    reg[i].data('active', false);
                                }
                            }
                        }
                        ssInpObj.data('active', true);
                        $('#MainContent').css('overflow', 'visible');
                        o.openTimeout = window.setTimeout(function () {
                            closeBtn.css('display', 'block');
                            resultWrap.css('display', 'block').find('.innerRes').css('display', 'block').addClass('js_active');
                            if (allEvents['closeSuggested'] == undefined) {
                                $(document).on('closeSuggested', function (event) {
                                    close();
                                });
                            }
                            if ($('body').hasClass('mobile')) {
                                $('body').click(function (event) {
                                    var target = $(event.target);
                                    var stopClosing = false;
                                    if (target.attr('id') != ssInpObj.attr('id')) {
                                        stopClosing = true;
                                    } else {
                                        if (stopClosing == false) {
                                            if (target.hasClass('res')) {
                                                stopClosing = true;
                                            } else if (target.hasClass('term')) {
                                                stopClosing = true;
                                            } else if (target.hasClass('hits')) {
                                                stopClosing = true;
                                            }
                                        }
                                        if (stopClosing == false) {
                                            $(this).trigger('closeSuggested');
                                        }
                                    }
                                });
                            } else {
                                ssInpObj.blur(function () {
                                    $('body').click(function (event) {
                                        if ($(event.target).attr('id') != ssInpObj.attr('id')) {
                                            $(this).trigger('closeSuggested');
                                        }
                                    });
                                });
                            }
                        }, o.openDelay);
                    }
                    var close = function (clearInput) {
                        var par = $('.js_active').parent().parent();
                        par.each(function () {
                            par.find('.btnClose').css('display', 'none');
                            par.find('.resWrap').css('display', 'none');
                            $('.js_active').css('display', 'none').removeClass('js_active');
                        });
                        if (clearInput === true) {
                            ssInpObj.val('');
                            ssInpObj.siblings('label').css('color', '#999999');
                        }
                        ssInpObj.data({
                            result: '',
                            lastInput: '',
                            active: false
                        });
                        resList.html('');
                        lastList.html('');
                        $('#MainContent').css('overflow', 'hidden');
                        $(document).off('closeSuggested');
                    }
                    ssInpObj.select(function () {
                        for (var i = 0; i < reg.length; i++) {
                            reg[i].data('parent').find('.btnClose').css('display', 'none');
                            reg[i].data('parent').find('.resWrap').css('display', 'none');
                            reg[i].data('parent').find('.js_active').css('display', 'none').removeClass('js_active');
                            reg[i].data('active', false);
                        }
                    });
                    var fetchData = function () {
                        if ($.trim(ssInpObj.val()) != '') {
                            ts = Math.round((new Date()).getTime() / 1000);
                            ssInpObj.data('sendtime', ts);
                            $.ajax(o.ajaxUrl, {
                                cache: false,
                                async: true,
                                data: ssInpObj.serialize() + '&ts=' + ts,
                                dataType: 'json',
                                type: o.ajaxRequest,
                                success: function (ajdata) {
                                    if (ajdata.suggestions.length > 0) {
                                        lock = false;
                                        var result = ajdata.suggestions;
                                        if (lock == false) {
                                            var sugHTML = prepareSuggestHTML(result);
                                            var lsHTML = prepareLastSearchHTML();
                                            resList.html(sugHTML);
                                            if (ssInpObj.data('lastSearch').length > 0) {
                                                lastList.html(lsHTML);
                                                lastList.css('display', 'block');
                                                seperator.css('display', 'block');
                                            } else {
                                                lastList.css('display', 'none');
                                                seperator.css('display', 'none');
                                            }
                                            resultWrap.find('li').hover(function () {
                                                var li = $(this);
                                                if (li.parent('ul').hasClass('js_sugSep') == false) {
                                                    toggleMoMarkup($(this));
                                                    o.selectCallBack();
                                                }
                                            }).click(function (event) {
                                                var li = $(this);
                                                if (li.parent('ul').hasClass('js_sugSep') == false) {
                                                    customSubmit();
                                                }
                                            });
                                            if (!resultWrap.hasClass('js_active')) {
                                                if ($.trim(ssInpObj.val()).length > 0) {
                                                    open();
                                                }
                                            }
                                        }
                                        o.ajaxSuccessCallBack();
                                    } else {
                                        o.ajaxErrorCallBack();
                                        close();
                                        lock = true;
                                    }
                                },
                                error: function (ajdata) {
                                    o.ajaxErrorCallBack();
                                    close();
                                    lock = true;
                                }
                            });
                        }
                    }
                    var prepareSuggestHTML = function (jsonObj) {
                        var $html = $('<div></div>');
                        for (e in jsonObj) {
                            if (jsonObj[e].ts == ssInpObj.data('sendtime')) {
                                var strTerm = jsonObj[e].term;
                                if ($.trim(ssInpObj.val()).length > 1) {
                                    var val = $.trim(ssInpObj.val().toLowerCase());
                                    strTerm = strTerm.toLowerCase();
                                    strTerm = strTerm.split(val);
                                    if (strTerm.length > 2) {
                                        strTerm.shift();
                                        strTerm = '<b>' + val + '</b>' + strTerm.join(val);
                                    } else {
                                        strTerm = strTerm.join('<b>' + val + '</b>');
                                    }
                                }
                                $html.append('<li class="res" suggest="' + jsonObj[e].term + '"><span class="term">' + strTerm + '</span><span class="hits">' + (jsonObj[e].hits != 0 ? jsonObj[e].hits : '') + '</span></li>');
                            }
                        }
                        return $html.html();
                    }
                    var prepareLastSearchHTML = function () {
                        var $html = $('<div></div>');
                        var ls = ssInpObj.data('lastSearch');
                        for (var i = 0; i < ls.length; i++) {
                            $html.append('<li class="res" suggest="' + ls[i] + '"><span class="term">' + ls[i] + '</span></li>');
                        }
                        return $html.html();
                    }
                    var toggleMoMarkup = function (domElm) {
                        domElm.parents(o.parent).find('.active').removeClass('active');
                        domElm.addClass('active');
                    }
                    var toggleKeyMarkUp = function (direction) {
                        var allElms = null;
                        allElms = resList.find('li');
                        allElms = $.merge(allElms, lastList.find('li'));
                        var aktObj = resultWrap.find('li.active');
                        var ssInpObjFound = aktObj.length;
                        var aktindex = -1;
                        aktObj.removeClass('active');
                        lock = true;
                        if (ssInpObjFound == 1) {
                            aktindex = allElms.index(aktObj);
                        }
                        if (direction == 'up') {
                            if (aktindex > 0) {
                                aktindex--;
                            } else {
                                aktindex = -1;
                            }
                        } else {
                            if (aktindex < allElms.length - 1) {
                                aktindex++;
                            } else {
                                aktindex = -1;
                            }
                        }
                        if (aktindex != -1) {
                            aktObj = $(allElms[aktindex]);
                            aktObj.addClass('active');
                            ssInpObj.val(aktObj.attr('suggest')).focus();
                        } else {
                            ssInpObj.val(ssInpObj.data('lastInput')).focus();
                        }
                        o.selectCallBack();
                        return false;
                    }
                    var timeoutSubmit = function () {
                        form.submit();
                    }
                    var customSubmit = function () {
                        lock = true;
                        var submittime = 0;
                        if ($.trim(ssInpObj.val()) == '') {
                            form.submit(function () {
                                return false;
                            });
                        } else {
                            if (resultWrap.find('li.active').length > 0) {
                                ssInpObj.val(resultWrap.find('li.active').attr('suggest'));
                            }
                            close();
                            if ($('body').hasClass('mobile') == false) {
                                ssInpObj.focus();
                            }
                            if ($('body').hasClass('mobile')) {
                                submittime = o.tabletTime * 4;
                            }
                            o.submitTimeout = window.setTimeout(timeoutSubmit, submittime);
                        }
                    }
                    var ajaxKeyFire = function (objElement, eventArg) {
                        objElement.bind(eventArg, function (e) {
                            if ($.inArray(e.which, keyValues) == -1) {
                                var val = $.trim(ssInpObj.val());
                                if ($('body').hasClass('mobile')) {
                                    ssInpObj.data('lastInput', val);
                                }
                                if (val.length >= (o.minInput - 1)) {
                                    if (o.requestTimeout != undefined || o.requestTimeout != null) {
                                        window.clearTimeout(o.requestTimeout);
                                    }
                                    o.requestTimeout = window.setTimeout(function () {
                                        if (e.which == 8 && val.length <= 1) {
                                            close();
                                            return;
                                        } else {
                                            fetchData();
                                        }
                                    }, o.ajaxWait);
                                }
                                if (e.which == 8) {
                                    ssInpObj.focus();
                                    if ($.trim(ssInpObj.val()).length <= 1) {
                                        close(true);
                                    }
                                    return true;
                                }
                            }
                        });
                    }
                    closeBtn.click(function () {
                        close(true);
                    });
                    var keyFunction = function (objElement, eventArg) {
                        var eventexists = objElement.data('events');
                        if (eventexists == undefined || eventexists[eventArg] == undefined) {
                            objElement.bind(eventArg, function (e) {
                                var pressed = e.which;
                                if ($.inArray(pressed, keyValues) != -1) {
                                    if (pressed == 38) {
                                        toggleKeyMarkUp('up');
                                        return false;
                                    } else if (pressed == 40) {
                                        toggleKeyMarkUp('down');
                                        return false;
                                    } else if (pressed == 27 || pressed == 9) {
                                        close();
                                        if (pressed == 27) {
                                            return false;
                                        }
                                        return true;
                                    } else if (pressed == 13) {
                                        e.preventDefault();
                                        customSubmit();
                                        return false;
                                    }
                                    return false;
                                }
                            });
                        }
                    }
                    if ($('body').hasClass('mobile') == false) {
                        ssInpObj.keyup(function (e) {
                            var kpress = e.which;
                            if ($.inArray(kpress, keyValues) == -1) {
                                ssInpObj.data('lastInput', $.trim(ssInpObj.val()));
                            }
                        });
                    }
                    ajaxKeyFire(ssInpObj, 'keydown');
                    keyFunction($(o.parent), 'keydown');
                    if ($('body').hasClass('mobile')) {
                        ajaxKeyFire(ssInpObj, 'keypress');
                    }
                    if (ssInpObj.parents('.ContentBox_2x2').length > 0) {
                        ssInpObj.parents('.ContentBox_2x2').css('overflow', 'visible');
                    }
                });
            },
            get: function (key) {
                defaults[key];
            },
            set: function (key, value) {
                defaults[key] = value;
            }
        };
        $.fn.suggestedSearch = function (method) {
            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                return methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + ' does not exist on jQuery.suggestedSearch');
            }
        };
    })(jQuery);;
$(document).ready(function () {
    GeneralJS.identifyUA();
    GeneralJS.toggleSearchInput($('#sugWrap'));
    GeneralJS.toggleSearchInput($('#contentSWrap'));
    $('#Header').find('.js_searchinp').focus();
    $('#footer').ready(function () {
        GeneralJS.clearOnFocus($('#footer'));
    });
    $('div.ProductCinema').each(function () {
        GeneralJS.appendButtonFeats($(this));
    });
    $(window).load(function () {
        $('div.ImgCarrusel').each(function () {
            GeneralJS.initCarrusel($(this));
        });
    });
    $('div.ImgSwitcher').each(function () {
        GeneralJS.initImgSwitcher($(this));
    });
    $('#ShadowboxFooter').each(function () {
        var FooterHTML = $(this).html();
        parent.Shadowbox.setFooter(FooterHTML);
    });
    $('.ConversionTeaser').each(function () {
        GeneralJS.initConversionTeaser($(this));
    });
    $('.HalfteaserObj').each(function () {
        GeneralJS.initHalfTeaser($(this));
    });
    $('.vft').each(function () {
        GeneralJS.initvft($(this));
    });
    $(window).resize(function () {
        GeneralJS.ResizeOverlay($('#filterOverlay'));
        GeneralJS.ResizeThrobber();
        GeneralJS.ResizeThrobber();
    });
    $('.ADSSizePick').each(function () {
        GeneralJS.sizepick($(this));
    })
    $('.ADSColPick').each(function () {
        GeneralJS.colorpick($(this));
    })
    $('.Slider').each(function () {
        GeneralJS.initadsimgslider($(this));
    });
    $('.Slider7Step').each(function () {
        GeneralJS.initadsimgslider7step($(this));
    });
    $('.sitmapent a').click(function () {
        return GeneralJS.nextSitemapLevel($(this));
    });
    $('.jigTxt a.js_jigMore').click(function () {
        return GeneralJS.toggleJigTxt($(this));
    });
});
$(function () {
    $('#MGM').ready(function () {
        $('.js_mgm_showall').click(function () {
            GeneralJS.toggleMgmShowAll($(this));
            return false;
        });
        $('.js_vccheckbox').click(function () {
            return GeneralJS.checkMgmChkBoxes();
        });
        GeneralJS.checkMgmChkBoxes();
    });
    $('#ccData').ready(function () {
        $('.js_ciParent input.Radio').click(function () {
            var parent = $(this).parents('.js_ciParent');
            var info = parent.find('.js_cardInfo');
            if ($('.js_toggleCC').is(':checked')) {
                info.addClass('active');
            } else {
                info.removeClass('active');
            }
        });
    });
    $('.ADS2Reiter').click(function (callback) {
        GeneralJS.SetADSAct($(this).attr('id'));
        return false;
    });
    $('.ADS2PReiter').click(function () {
        GeneralJS.SetADSPAct($(this).attr('id'));
        return false;
    });
    $('.filWrap').click(function () {
        GeneralJS.ShowFilter($(this));
    });
    $('#filterOverlay').click(function () {
        GeneralJS.HideFilter($(this));
    });
    $('a.topJump').click(function (e) {
        e.preventDefault();
        $.scrollTo('#Top', 100);
    });
    $('a#ServiceSelectLink').hover(function () {
        TimeSettings['ServiceBox'] = window.setTimeout("GeneralJS.ShowServiceLayer()", MainnavigationTime);
    }, function () {
        TimeSettings['ServiceBox'] = window.setTimeout("GeneralJS.HideServiceLayer()", MainnavigationTime);
    });
    $('#ServiceSelectBox').hover(function () {
        window.clearTimeout(TimeSettings['ServiceBox']);
    }, function () {
        TimeSettings['ServiceBox'] = window.setTimeout("GeneralJS.HideServiceLayer()", MainnavigationTime);
    });
    $('.MNA').hover(function () {
        var category = $(this).attr('cat');
        window.clearTimeout(TimeSettings[category]);
        var colorset = $(this).attr('col');
        var position = $(this).position();
        var postionMN = $('div#MainNavigation').position();
        var LayerHeight = $('div#MainNavigation').outerHeight() - position.top + postionMN.top + 20;
        var negativmargin = $(this).css("margin-left");
        var LayerWidth = $(this).outerWidth() + $('span#MNP' + category).outerWidth();
        TimeSettings[category] = window.setTimeout("GeneralJS.ShowMainnavigationLayer('" + category + "','" + colorset + "','" + (position.top) + "px','" + (position.left + parseInt(negativmargin)) + "px','" + LayerWidth + "px','" + LayerHeight + "px')", MainnavigationTime);
    }, function () {
        var category = $(this).attr('cat');
        var colorset = $(this).attr('col');
        window.clearTimeout(TimeSettings[category]);
        TimeSettings[category] = window.setTimeout("GeneralJS.HideMainnavigationLayer('" + category + "','" + colorset + "')", MainnavigationTime);
    })
    $('.MNH').hover(function () {
        var category = $(this).attr('cat');
        window.clearTimeout(TimeSettings[category]);
    }, function () {
        var category = $(this).attr('cat');
        var colorset = $(this).attr('col');
        TimeSettings[category] = window.setTimeout("GeneralJS.HideMainnavigationLayer('" + category + "','" + colorset + "')", (MainnavigationTime / 2));
    })
    $('.MNA2').hover(function () {
        var category = $(this).attr('cat');
        window.clearTimeout(TimeSettings[category]);
        var colorset = $(this).attr('col');
        var position = $(this).position();
        var postionMN = $('div#MainNavigation').position();
        var LayerHeight = $('div#MainNavigation').outerHeight() - position.top + postionMN.top + 20;
        var negativmargin = $(this).css("margin-left");
        var LayerWidth = $(this).outerWidth() + $('span#MNP' + category).outerWidth();
        TimeSettings[category] = window.setTimeout("GeneralJS.ShowMNL('" + category + "','" + colorset + "','" + (position.top) + "px','" + (position.left + parseInt(negativmargin)) + "px','" + LayerWidth + "px','" + LayerHeight + "px')", MainnavigationTime);
    }, function () {
        var category = $(this).attr('cat');
        var colorset = $(this).attr('col');
        window.clearTimeout(TimeSettings[category]);
        TimeSettings[category] = window.setTimeout("GeneralJS.HideMNL('" + category + "','" + colorset + "')", MainnavigationTime);
    })
    $('.MNH2').hover(function () {
        var category = $(this).attr('cat');
        window.clearTimeout(TimeSettings[category]);
    }, function () {
        var category = $(this).attr('cat');
        var colorset = $(this).attr('col');
        TimeSettings[category] = window.setTimeout("GeneralJS.HideMNL('" + category + "','" + colorset + "')", (MainnavigationTime / 2));
    })
    $('#BC .BCWrap').hover(function () {
        var id = $(this).attr('id');
        TimeSettings['BC' + id] = window.setTimeout("GeneralJS.ShowBCL('" + id + "')", (MainnavigationTime));
    }, function () {
        var id = $(this).attr('id');
        window.clearTimeout(TimeSettings['BC' + id]);
        TimeSettings['BC' + id] = window.setTimeout("GeneralJS.HideBCL('" + id + "')", (MainnavigationTime));
    })
    $('li.pullUp > h4').live('click', function () {
        var parent = $(this).parents('ul');
        if (parent.hasClass('rate')) {
            GeneralJS.switchPullUpAndRating($(this));
        } else {
            GeneralJS.switchPullUp($(this));
            GeneralJS.resetSitemap();
        }
        if (parent.attr('rel')) {
            objelements = parent.children('li.pullUp');
            objelementsact = parent.children('li.pullDown');
            var objlink = $('#' + parent.attr('rel'));
            var rel = objlink.attr('rel').split('|');
            if (objelementsact.length >= objelements.length) {
                objlink.text(rel[1]);
            } else {
                objlink.text(rel[0]);
            }
        }
    })
    $('.sitemapMain li.pullUp > h4').live('click', function () {
        var parent = $(this).parents('ul');
        if (parent.hasClass('rate')) {
            GeneralJS.switchPullUpAndRating($(this));
        } else {
            $('.pullDown').removeClass('pullDown');
            GeneralJS.switchPullUp($(this));
            GeneralJS.resetSitemap();
        }
        if (parent.attr('rel')) {
            objelements = parent.children('li.pullUp');
            objelementsact = parent.children('li.pullDown');
            var objlink = $('#' + parent.attr('rel'));
            var rel = objlink.attr('rel').split('|');
            if (objelementsact.length >= objelements.length) {
                objlink.text(rel[1]);
            } else {
                objlink.text(rel[0]);
            }
        }
    })
    $('div.FilterLink').hover(function () {
        var FilterCategory = $(this).attr('id');
        window.clearTimeout(TimeSettings[FilterCategory]);
        TimeSettings[FilterCategory] = window.setTimeout("$('#" + FilterCategory + "').addClass('FilterOver');", (MainnavigationTime));
    }, function () {
        var FilterCategory = $(this).attr('id');
        window.clearTimeout(TimeSettings[FilterCategory]);
        TimeSettings[FilterCategory] = window.setTimeout("$('#" + FilterCategory + "').removeClass('FilterOver');", (MainnavigationTime));
    })
    $('select#SelectCountry').change(function () {
        $('.addresses').hide();
        $('.' + $(this).attr('value')).show();
    })
    $('.goToProductInformations').click(function () {
        $.scrollTo($('div.ArticleBox'), 1000);
        return false;
    })
    $('.ArticleBoxLink').click(function () {
        targetId = $(this).attr('OpenId');
        $('.ArticleNavi').children('div.TabActiv').attr('class', 'TabInActiv');
        $('.ArticleNavi').children('div.TabActivGelb').attr('class', 'TabInActivGelb');
        var thisobj = $(this).parent();
        if (thisobj.hasClass('TabInActiv')) {
            thisobj.attr('class', 'TabActiv');
        } else if (thisobj.hasClass('TabInActivGelb')) {
            thisobj.attr('class', 'TabActivGelb');
        }
        $('.ArticleBoxWrapper').hide();
        $('#' + targetId).show();
        return false;
    })
    $('.toggleAllSlider').click(function () {
        var action = $(this).attr('action');
        var thisId = $(this).attr('toogleSliderId');
        switch (action) {
            case 'open':
                $('ul#' + thisId).children('li').each(function () {
                    $(this).addClass('pullDown');
                });
                $(this).attr('action', 'close');
                $(this).children('span').html('<b>&raquo; ' + closeAll + '</b>');
                break;
            case 'close':
                $('ul#' + thisId).children('li').each(function () {
                    $(this).removeClass('pullDown');
                });
                $(this).attr('action', 'open');
                $(this).children('span').html('<b>&raquo; ' + expandAll + '</b>');
                break;
        }
        return false;
    })
    $('.toggleRatingSliders').click(function () {
        GeneralJS.toggleRatingSliders($(this));
    });
    $('.togpu').click(function () {
        GeneralJS.togglePullUp($(this));
    });
    $('.CheckboxSwitch').click(function () {
        GeneralJS.CheckboxSwitch($(this));
    })
    $('.cbsgle').click(function () {
        GeneralJS.CheckboxSingle($(this));
    })
    $('a.OfferSwitch').click(function () {
        $('a#OfferImage').attr('href', $(this).attr('href'));
        $('a#OfferImage').attr('title', $(this).attr('title'));
        $('a#OfferImage > img').attr('alt', $(this).attr('title'));
        $('a#OfferImage > img').attr('src', $(this).attr('src'));
    })
    $('.PCmaSwitch.active').each(function () {
        GeneralJS.initpcma($(this));
    });
    $('.PCmaReiter a').click(function () {
        GeneralJS.switchpcma($(this));
    });
    $('#adsLclose a').click(function () {
        GeneralJS.closeL2();
        return false;
    });
    $('#kndover').hover(function () {
        var objLink = $(this);
        TimeSettings['KDLayer'] = window.setTimeout(function () {
            GeneralJS.openL2(objLink.attr('href'), 0, 0, document.getElementById('kndover'), true);
        }, 1000);
    }, function () {
        window.clearTimeout(TimeSettings['KDLayer']);
    });
});
var GeneralJS = {
    ResizeThrobber: function () {
        var throbber = $('#throbber');
        var theight = throbber.parents('.Relative').height() - $('.Footer').outerHeight(true) - $('#BreadCrumb').outerHeight(true);
        var twidth = throbber.parents('.Relative').width();
        throbber.css({
            top: $('#BreadCrumb').outerHeight(true) + 'px',
            width: twidth + 'px',
            height: theight + 'px'
        });
    },
    openThrobber: function () {
        var throbber = $('#throbber');
        GeneralJS.ResizeThrobber();
        throbber.css({
            display: 'block'
        }).addClass('active');
        GeneralJS.HideFilter($('#filterOverlay'));
    },
    closeThrobber: function () {
        var throbber = $('#throbber');
        throbber.css({
            display: 'none'
        }).removeClass('active');
    },
    identifyUA: function () {
        var ua = navigator.userAgent;
        var found = null;
        var browsers = new Array('firefox', 'chrome', 'opera', 'safari', 'msie');
        ua = ua.toLowerCase();
        for (var i = 0; i < browsers.length; i++) {
            if (ua.search(new RegExp(browsers[i], 'i')) != -1) {
                found = browsers[i];
                break;
            }
        }
        if (ua.match(/MSIE 9/i)) {
            $('body').addClass('ie9');
        }
        if (ua.match(/MSIE 8/i)) {
            $('body').addClass('ie8');
        }
        if (ua.match(/MSIE 7/i)) {
            $('body').addClass('ie7');
        }
        if (ua.match(/iPad/i)) {
            $('body').addClass('ipad');
        }
        if (ua.match(/Android/i)) {
            $('body').addClass('android');
        }
        $('body').addClass(found);
        return found;
    },
    toggleInpageItem: function (obj) {
        var cont = obj.find('.filContWrap');
        window.clearTimeout(TimeSettings['InpageItem']);
        if (!obj.hasClass('filIsSel')) {
            obj.addClass('filIsSel');
        } else {
            obj.removeClass('filIsSel');
        }
        obj.mouseleave(function () {
            TimeSettings['InpageItem'] = window.setTimeout(function () {
                obj.removeClass('filIsSel');
                cont.slideUp('fast');
                $('div#MainContent').css('overflow', 'hidden');
            }, 1500);
        });
        cont.mouseenter(function () {
            window.clearTimeout(TimeSettings['InpageItem']);
        });
        cont.mouseleave(function () {
            TimeSettings['InpageItem'] = window.setTimeout(function () {
                obj.removeClass('filIsSel');
                cont.slideUp('fast');
                $('div#MainContent').css('overflow', 'hidden');
            }, 1500);
        });
        cont.slideToggle('fast');
        $('div#MainContent').css('overflow', 'visible');
    },
    clearOnFocus: function (parElement) {
        objElement = parElement.find('.js_searchinp');
        var val = objElement.val();
        objElement.data('oldText', val);
        var oldColor = objElement.css('color');
        objElement.data('oldColor', oldColor);
        objElement.focus(function () {
            $(this).val("");
            $(this).css('color', '#212121');
        });
        objElement.blur(function () {
            if ($(this).val() == "") {
                $(this).val(val);
                $(this).css('color', oldColor);
            }
        });
    },
    toggleSearchInput: function (parElement) {
        var objElement = parElement.find('.js_searchinp');
        var objLabel = parElement.find('label');
        var bgCol = '#ffffff';
        var fCol = '#999999';
        var val = '';
        if (objElement.val() != '') {
            objLabel.css('color', bgCol);
            objElement.focus();
        }
        objElement.keydown(function () {
            objLabel.css('color', bgCol);
        });
        objElement.keyup(function () {
            val = $.trim(objElement.val());
            if (val == '') {
                objLabel.css('color', fCol);
            }
        });
        objElement.blur(function () {
            val = $.trim(objElement.val());
            if (val == '') {
                objLabel.css('color', fCol);
            }
        });
    },
    checkMgmChkBoxes: function () {
        var mgm_chkboxCount = 0;
        $('.js_vccheckbox').each(function () {
            var deactLayer = $(this).siblings('.js_deactLayer');
            deactLayer.unbind('click');
            deactLayer.click(function () {
                deactLayer.trigger('mgm_deactivated_click');
            });
            if ($(this).prop('checked')) {
                mgm_chkboxCount++;
            }
            if (mgm_chkboxCount >= 2) {
                $('.js_vccheckbox').attr('disabled', true);
                $('.js_vccheckbox').each(function () {
                    if ($(this).prop('checked')) {
                        $(this).removeAttr('disabled');
                        $(this).siblings('.js_deactLayer').css('display', 'none');
                    } else {
                        $(this).siblings('.js_deactLayer').css('display', 'block');
                    }
                });
            } else {
                $('.js_vccheckbox').removeAttr('disabled');
                $('.js_deactLayer').css('display', 'none');
            }
        });
        if ($('#MGM').hasClass('js_hasvccheck') && mgm_chkboxCount < 2) {
            $('#MGM').trigger('mgm_free_checkboxes');
        }
    },
    toggleMgmShowAll: function (objElement) {
        objElement.parents('.js_mgm_showall_cont').hide(1);
        $('.js_hidvouchers').show(1);
        objElement.trigger('mgm_vouchers_showed');
    },
    initMassArtikel: function (thisElement, min, max, increment, unit, unitname, start) {
        return thisElement.massartikel({
            'minQuantity': min,
            'maxQuantity': max,
            'incrementQuantity': increment,
            'unit': unit,
            'unitName': unitname,
            'startValue': start
        });
    },
    initMassArtikelID: function (thisElementID, min, max, increment, unit, unitname, start) {
        return GeneralJS.initMassArtikel($('#' + thisElementID), min, max, increment, unit, unitname, start);
    },
    nextSitemapLevel: function (thisElement) {
        var nextLvlUl = thisElement.siblings('ul');
        var bgWrap = thisElement.parents('.fauxCol');
        var nextClass = nextLvlUl.attr('class');
        var nextUlHeight = nextLvlUl.outerHeight();
        var parentLi = thisElement.parent('li');
        var parentUl = parentLi.parent('ul');
        var nextLvl = 0;
        var countActive = bgWrap.find('.Activ');
        var childLi = nextLvlUl.find('li');
        if (parentUl.hasClass('sitmaplvl_2') == false) {
            if (childLi.length == 0) {
                return true;
            }
            if (thisElement.hasClass('Activ')) {
                GeneralJS.resetSitemapAncestors(thisElement);
                return false;
            } else {
                if (countActive.length > 0) {
                    GeneralJS.resetSitemapAncestors(parentUl.children('li.Open').find('a.Activ'));
                }
            }
            if (nextClass != undefined) {
                var cut = nextClass.lastIndexOf('_') + 1;
                nextLvl = nextClass.substr(cut, nextClass.length);
                if (nextUlHeight > parentUl.outerHeight()) {
                    bgWrap.css('height', nextUlHeight);
                }
                nextLvlUl.css('display', 'block');
                bgWrap.removeClass('maplvl_1');
                bgWrap.removeClass('maplvl_2');
                bgWrap.addClass('maplvl_' + nextLvl);
                thisElement.addClass('Activ');
                parentLi.addClass('Open');
            }
            return false
        } else {
            return true;
        }
    },
    resetSitemapAncestors: function (thisElement) {
        var bgWrap = thisElement.parents('.fauxCol');
        var rootUl = thisElement.parents('sitmap');
        var parentLi = thisElement.parent('li');
        var parentUl = parentLi.parent('ul');
        var childrenUls = parentLi.find('ul');
        var childrenOpens = parentLi.find('li.Open');
        var childrenActives = parentLi.find('.Activ');
        childrenUls.removeAttr('style');
        thisElement.removeClass('Activ');
        parentLi.removeClass('Open');
        childrenOpens.removeClass('Open');
        childrenActives.removeClass('Activ');
        bgWrap.css('height', parentUl.height());
        if (parentUl.hasClass('sitmaplvl_0')) {
            bgWrap.removeAttr('class').addClass('fauxCol');
        } else if (parentUl.hasClass('sitmaplvl_1')) {
            bgWrap.removeAttr('class').addClass('fauxCol').addClass('maplvl_1');
        }
    },
    resetSitemap: function () {
        var fauxcol = $('.fauxCol')
        fauxcol.removeClass('maplvl_1');
        fauxcol.removeClass('maplvl_2');
        fauxcol.removeAttr('style').css('position', 'relative');
        $('.sitmaplvl_1').removeAttr('style');
        $('.sitmaplvl_2').removeAttr('style');
        $('.fauxCol .Activ').each(function () {
            $(this).removeClass('Activ');
        });
        $('.fauxCol .Open').each(function () {
            $(this).removeClass('Open');
        });
    },
    initBilderstrahl: function (thisElementID) {
        var parent = $('#' + thisElementID);
        var slider = parent.find('.Slider');
        var reiter = parent.find('.ADS2PReiter');
        var sevenstep = parent.find('.Slider7Step');
        if (reiter.length > 0) {
            reiter.click(function () {
                GeneralJS.SetADSPAct($(this).attr('id'));
                return false;
            });
        }
        if (slider.length > 0) {
            GeneralJS.initadsimgslider(slider);
        }
        if (sevenstep.length > 0) {
            GeneralJS.initadsimgslider7step(sevenstep);
        }
    },
    initsizepickid: function (thisElementID) {
        GeneralJS.sizepick($('#' + thisElementID));
    },
    sizepick: function (objsizepick) {
        var act = objsizepick.find('.actSiz').children('a').html();
        var objsizepreview = objsizepick.find('#sName');
        var sizecont = objsizepick.find('.sizClk');
        var sizelink = sizecont.children('a');
        objsizepreview.html(act);
        sizelink.click(function () {
            if ($(this).parent('li').hasClass('deactSiz') == false) {
                act = $(this).html();
                objsizepreview.html(act);
                sizecont.removeClass('actSiz');
                $(this).parent().addClass('actSiz');
            }
        });
        sizelink.hover(function () {
            if ($(this).parents('.siz').hasClass('actSiz')) {
                objsizepreview.css('font-weight', 'bold');
            } else {
                objsizepreview.css('font-weight', 'normal');
            }
            objsizepreview.html($(this).html());
        }, function () {
            objsizepreview.removeAttr('style');
            objsizepreview.html(act);
        });
    },
    initcolpickid: function (thisElementID) {
        GeneralJS.colorpick($('#' + thisElementID));
    },
    colorpick: function (objcolpick) {
        var act = objcolpick.find('.actCol ').children('a').attr('rel');
        var objsizepreview = objcolpick.find('#cName');
        var sizecont = objcolpick.find('.colClk');
        var sizelink = sizecont.children('a');
        objsizepreview.html(act);
        sizelink.click(function () {
            if ($(this).parent('li').hasClass('coldeact') == false) {
                act = $(this).attr('rel');
                objsizepreview.html(act);
                sizecont.removeClass('actCol');
                $(this).parent().addClass('actCol');
            }
        });
        sizelink.hover(function () {
            if ($(this).parents('.col').hasClass('actCol')) {
                objsizepreview.css('font-weight', 'bold');
            } else {
                objsizepreview.css('font-weight', 'normal');
            }
            objsizepreview.html($(this).attr('rel'));
        }, function () {
            objsizepreview.removeAttr('style');
            objsizepreview.html(act);
        });
    },
    switchpcma: function (objlink) {
        var objparent = objlink.parents('div.PCma');
        objparent.find('.PCmaReiter').removeClass('active');
        objlink.parent().addClass('active');
        var objpcma = objparent.find('.' + objlink.attr('rel'));
        objparent.find('.PCmaSwitch').css('display', 'none');
        objpcma.css('display', 'block');
        if (!objpcma.hasClass('active')) {
            objpcma.addClass('active');
            GeneralJS.initpcma(objpcma);
        }
        return false;
    },
    initpcma: function (objwrap) {
        var intlilen = 127;
        var pos = 0;
        var objcont = objwrap.find('div.PCmaCont');
        var objulwrap = objcont.find('div.PCmaListWrap')
        var objul = objcont.find('ul.PCmaList');
        var objli = objul.children('li[class!="clear"]');
        var intcontiw = objcont.innerWidth();
        var intaktpointer;
        var intposaktiv = Math.floor(intcontiw / intlilen);
        intaktpointer = Math.ceil(intposaktiv / 2);
        if (objli.length > intposaktiv) {
            intposaktiv = Math.ceil(intposaktiv / 2);
        } else {
            intposaktiv = Math.ceil(objli.length / 2);
            pos = 0 - (intlilen * intposaktiv) + (intlilen * intaktpointer);
            objul.css('left', pos + 'px');
        }
        var intmin = 0 - (intposaktiv - 1) * intlilen;
        var objrangewrap = objwrap.find('.scroll-bar-horz');
        var objrange = objrangewrap.find('input');
        var objlilen = objul.children('li[class!="clear"]');
        var intulwidth = objli.length * intlilen + 51;
        objul.css('width', intulwidth + 'px');
        intulwidth = intulwidth + intmin - intlilen;
        objact = objul.find('li.PCmaS' + intposaktiv);
        objact.addClass('act');
        var objimg = objact.find('img');
        objact.css('width', '171px');
        objimg.css('height', '165px');
        objrangewrap.mousedown(function () {
            objwrap.find('a.handle').addClass('locked');
            var objActiveLi = objul.find('li.act');
            var objActiveImg = objActiveLi.find('img');
            objActiveLi.animate({
                width: '120px'
            }, 50);
            objActiveImg.animate({
                height: '118px'
            }, 50);
        });
        objrange.rangeinput({
            min: intmin,
            max: intulwidth,
            value: 0,
            step: 1,
            stepwidth: intlilen,
            actObj: 1,
            keyboard: true,
            rootElmt: objcont,
            onSlide: function (ev, step) {
                objul.css('left', -step + 'px');
                if (objwrap.find('a.handle').hasClass('locked')) {
                    objwrap.find('a.handle').removeClass('locked');
                }
                var intIndicator = Math.round(step / intlilen);
                objul.find('li.act').removeClass('act');
                intnewposaktiv = intposaktiv + intIndicator;
                var newObj = objul.find('li.PCmaS' + intnewposaktiv);
                newObj.addClass('act');
            },
            change: function (e, i) {
                objul.css('left', -i + 'px');
                if (objwrap.find('a.handle').hasClass('locked')) {
                    objwrap.find('a.handle').removeClass('locked');
                }
                var intIndicator = Math.round(i / intlilen);
                objul.find('.act').removeClass('act');
                intnewposaktiv = intposaktiv + intIndicator;
                var newObj = objul.find('li.PCmaS' + intnewposaktiv);
                newObj.addClass('act');
            },
            onstart: function (e, i) {}
        });
    },
    initadsimgslider: function (objslider) {
        var slideswidth = 53;
        var left = objslider.find('.switchLeft');
        var right = objslider.find('.switchRight');
        var slides = objslider.find('.slides');
        var slidesobj = slides.find('.siglSld');
        var slideslink = slidesobj.find('a');
        var linkact = 1;
        left.click(function () {
            linkact--;
            if (linkact < 1) {
                linkact = 1;
            }
            if (linkact <= 1) {
                left.css('display', 'none');
            }
            if (linkact < slidesobj.length) {
                right.css('display', 'block');
            }
            if ((linkact + 1) < slidesobj.length && (linkact - 2) > 0) {
                var newpos = 0 - ((linkact - 2) * slideswidth) + slideswidth;
                slides.animate({
                    left: newpos + 'px'
                }, 'fast');
            }
            slidesobj.removeClass('actSld');
            slides.find('a[rel="' + linkact + '"]').parent().addClass('actSld');
        })
        right.click(function () {
            linkact++;
            if (linkact > slidesobj.length) {
                linkact = slidesobj.length;
            }
            if (linkact >= slidesobj.length) {
                right.css('display', 'none');
            }
            if (linkact > 1) {
                left.css('display', 'block');
            }
            if ((linkact + 1) < slidesobj.length && (linkact - 2) > 0) {
                var newpos = 0 - ((linkact - 2) * slideswidth) + slideswidth;
                slides.animate({
                    left: newpos + 'px'
                }, 'fast');
            }
            slidesobj.removeClass('actSld');
            slides.find('a[rel="' + linkact + '"]').parent().addClass('actSld');
        })
        slideslink.click(function () {
            linkact = parseInt($(this).attr('rel'));
            if (linkact <= 1) {
                left.css('display', 'none');
            } else if (linkact > 1) {
                left.css('display', 'block');
            }
            if (linkact >= slidesobj.length) {
                right.css('display', 'none');
            } else if (linkact < slidesobj.length) {
                right.css('display', 'block');
                if (linkact <= 1) {
                    left.css('display', 'none');
                }
            }
            if ((linkact + 3) > slidesobj.length) {
                if (slidesobj.length > 5) {
                    var newpos = 0 - ((slidesobj.length - 4) * slideswidth) + slideswidth;
                } else {
                    var newpos = 0;
                }
            } else if ((linkact - 2) < 1) {
                var newpos = 0;
            } else {
                var newpos = 0 - ((linkact - 2) * slideswidth) + slideswidth;
            }
            slides.animate({
                left: newpos + 'px'
            }, 'fast');
            slidesobj.removeClass('actSld');
            slides.find('a[rel="' + linkact + '"]').parent().addClass('actSld');
        });
    },
    initadsimgslider7stepId: function (thisElementID) {
        GeneralJS.initadsimgslider7step($('#' + thisElementID));
    },
    initadsimgslider7step: function (objslider) {
        var slideswidth = 53;
        var left = objslider.find('.switchLeft');
        var right = objslider.find('.switchRight');
        var slides = objslider.find('.slides');
        var slidesobj = slides.find('.siglSld');
        var slideslink = slidesobj.find('a');
        var linkact = 1;
        left.click(function () {
            linkact--;
            if (linkact < 1) {
                linkact = 1;
            }
            if (linkact <= 1) {
                left.css('display', 'none');
            }
            if (linkact < slidesobj.length) {
                right.css('display', 'block');
            }
            var newpos = 0 - linkact * slideswidth + slideswidth;
            slides.animate({
                left: newpos + 'px'
            }, 'fast');
        })
        right.click(function () {
            linkact++;
            if (linkact > 1) {
                left.css('display', 'block');
            }
            var viewmax = slidesobj.length - 4;
            if (linkact > viewmax) {
                linkact = viewmax;
            }
            if (linkact >= viewmax) {
                right.css('display', 'none');
            }
            var newpos = 0 - linkact * slideswidth + slideswidth;
            slides.animate({
                left: newpos + 'px'
            }, 'fast');
        })
        slideslink.mouseover(function () {
            var linkover = parseInt($(this).attr('rel'));
            slidesobj.removeClass('actSld');
            slides.find('a[rel="' + linkover + '"]').parent().addClass('actSld');
        });
    },
    SetADSAct: function (id) {
        var index = id.substr(4, id.length);
        var rel = $('#' + id).find('a').attr('rel');
        var customFunc = function () {
            return false;
        };
        if (rel != null && rel != undefined && rel != '') {
            try {
                var customFunc = eval(rel);
                if ($.isfunction(customFunc) && customFunc != undefined) {
                    customFunc();
                }
            } catch (e) {}
        }
        $('.ADSRWrap .active').removeClass('active');
        $('#' + id).addClass('active');
        $('.ADSConWrap').css('display', 'none');
        $('#ADSC' + index).css('display', 'block');
        return false;
    },
    ProductSlide: function (objElement) {
        var parent = objElement.parent('.Slider');
        var id = objElement.attr('id');
        var direction = null;
        var slider = parent.find('.slides');
        var slideWidth = parent.find('.siglSld').outerWidth(true);
        var lock = false;
        if (lock == false) {
            var pos = slider.css('left');
            if (id.indexOf('right') == -1) {
                slideWidth = (-1 * slideWidth);
            }
            var newPos = parseInt(pos) + slideWidth;
            lock = true;
            slider.animate({
                left: newPos
            }, 'fast', function () {
                lock = false;
            });
        }
    },
    SetADSPAct: function (id) {
        var index = id.substr(5, id.length);
        $('.ADSPRWrap .active').removeClass('active');
        $('#' + id).addClass('active');
        $('.ADSPConWrap').css('display', 'none');
        $('#ADSPC' + index).css('display', 'block');
        $('#ADSPC' + index).find('.actSld').first().find('a').click();
        return false;
    },
    SetActivePicker: function (objElement, className) {
        if (objElement.hasClass('deactSiz') == false) {
            $('.' + className).removeClass(className);
            objElement.addClass(className);
        }
        return false;
    },
    ShowMainnavigationLayer: function (category) {
        $('div#MNS' + category).css('top', LayerPositionTop);
        $('div#MNS' + category).css('left', LayerPositionLeft);
        $('div#MNS' + category).css('width', LayerWidth);
        $('div#MNS' + category).css('height', LayerHeight);
        $('a#MNA' + category).addClass('Over');
        $('div#MNP' + category).addClass('CS' + colorset + 'Over');
        $('div#MNS' + category).css('display', 'block');
        $('div#MNL' + category).css('display', 'block');
    },
    HideMainnavigationLayer: function (category) {
        $('div#MNS' + category).css('display', 'none');
        $('div#MNL' + category).css('display', 'none');
        $('a#MNA' + category).removeClass('Over');
        $('div#MNP' + category).removeClass('CS' + colorset + 'Over');
    },
    ShowMNL: function (category) {
        $('div#MNS2' + category).css('display', 'block');
        $('div#MNL2' + category).css('display', 'block');
    },
    HideMNL: function (category) {
        $('div#MNS2' + category).css('display', 'none');
        $('div#MNL2' + category).css('display', 'none');
    },
    LoadMNL: function (arrLoadMNL) {
        for (x = 0; x < arrLoadMNL.length; x++) {
            GeneralJS.LoadMNLContent(arrLoadMNL[x]);
        }
    },
    LoadMNLContent: function (arrLoadMNL) {
        var thisurl = arrLoadMNL[0];
        var thiscategory = arrLoadMNL[1];
        $.get(thisurl, function (strhtml) {
            $('#MNLC2' + thiscategory).html(strhtml);
        });
    },
    ShowBCL: function (id) {
        var parent = $('#' + id);
        var aktObj = parent.children('.BCreit');
        var layer = parent.children('.BClayWrap');
        var position = aktObj.position();
        if (parent.hasClass('BCWrap')) {
            aktObj.addClass('BCrBord');
        }
        var rest = 980 - position.left - layer.width();
        if (rest <= 0) {
            layer.attr('style', 'display:block; left:' + (position.left - (layer.width() - aktObj.width()) + 20) + 'px;');
        } else {
            layer.attr('style', 'display:block; left:' + position.left + 'px;');
        }
    },
    HideBCL: function (id) {
        $('#' + id).children('.BCreit').removeClass('BCrBord');
        $('.BClayWrap').css('display', 'none');
    },
    LoadBCL: function (arrLoadBCL) {
        for (x = 0; x < arrLoadBCL.length; x++) {
            GeneralJS.LoadBCLContent(arrLoadBCL[x]);
        }
    },
    LoadBCLContent: function (arrLoadBCL) {
        var thisurl = arrLoadBCL[0];
        var thisobject = $('#BC' + arrLoadBCL[1]);
        $.get(thisurl, function (strhtml) {
            thisobject.find('.BClayWrap').html(strhtml);
        });
    },
    ResizeOverlay: function (overlay) {
        var lWidth = $(window).width();
        var lHeight = $(document).height();
        overlay.width(lWidth);
        overlay.height(lHeight);
    },
    ShowFilter: function (objElement) {
        var pos = objElement.offset();
        var posTop = pos.top + 24;
        var posLeft = pos.left;
        var rest = 0;
        var objAkt = $('#L' + objElement.attr('id'));
        var name = objAkt.find('.filName');
        var nameSort = objElement.find('.filSortName');
        var layer = objAkt.children('.filContWrap');
        var overlay = $('#filterOverlay');
        var masterlay = $('#filterMasterLayer');
        var seLwidth = $('#' + objElement.attr('id')).width();
        var secWidth = objAkt.width();
        if ($('#' + objElement.attr('id')).hasClass('flSortRight') == true) {
            seLwidth = secWidth;
        }
        if (objElement.parents('#filSortWrap').length > 0 && objElement.attr('id') == 'filterArticles') {
            objAkt.find('.filSelect').css({
                margin: '-20px 0 0'
            });
        }
        objAkt.removeClass('inActiveFilter');
        objAkt.addClass('activeFilter');
        objAkt.attr('style', 'top:' + posTop + 'px; left:' + posLeft + 'px;');
        objAkt.children('.filSelect').addClass('filIsSel');
        GeneralJS.ResizeOverlay(overlay);
        overlay.css('opacity', 0.6);
        overlay.css('display', 'block');
        masterlay.css('display', 'block');
        rest = 965 - posLeft - layer.outerWidth(true) + $('#Website').offset().left;
        if (rest <= 0) {
            layer.attr('style', 'display:block; left:' + (rest) + 'px;');
            if (layer.offset().left < 0) {
                layer.attr('style', 'display:block; left:' + (rest - layer.offset().left) + 'px;');
            }
        } else {
            layer.attr('style', 'display:block;');
        }
        if (nameSort.width() != null) {
            objAkt.children('.filSelect').css('left', nameSort.outerWidth());
            objAkt.children('.filContWrap').css('left', nameSort.outerWidth());
        }
        layer.css('position', 'absolute');
        layer.css('display', 'none');
        layer.offset();
        layer.css('display', 'block');
        GeneralJS.checkBoundaries(layer, $('#Website'), {
            left: 15
        });
        objAkt.find('.filArrD').click(function () {
            $(this).unbind('click');
            GeneralJS.HideFilter($('#filterOverlay'));
        });
        GeneralJS.scrollbarReinit(objAkt);
    },
    checkBoundaries: function (layer, wrapper, objMargins) {
        var lWidth = layer.width();
        var lHeight = layer.height();
        var wWidth = wrapper.width();
        var wHeight = wrapper.height();
        var lleftpos = layer.css('left');
        var ltoppos = layer.css('top');
        var loffset = layer.offset();
        var woffset = wrapper.offset();
        var lrightpos = loffset.left + lWidth;
        var lbotpos = loffset.top + lHeight;
        var lbrpos = lrightpos + lHeight;
        var wrightpos = woffset.left + wWidth;
        var wbotpos = woffset.top + wHeight;
        var wbrpos = wrightpos + wHeight;
        try {
            if (lWidth > wWidth) {
                throw new Error('Layerwidth bigger than Boundaries');
            }
            if (lHeight > wHeight) {
                throw new Error('Layerheight bigger than Boundaries');
            }
        } catch (e) {
            if (window.console) {
                if ($.type(console) == 'object') {
                    console.error(e.message);
                }
            }
        }
        if (objMargins == undefined || objMargins == null) {
            objMargins = {
                top: 0,
                left: 0
            };
        } else {
            if (objMargins.top == undefined || objMargins.top == null) {
                objMargins.top = 0;
            }
            if (objMargins.left == undefined || objMargins.left == null) {
                objMargins.left = 0;
            }
        }
        if (lrightpos > wrightpos) {
            layer.css({
                'left': parseInt(lleftpos) - (lrightpos - wrightpos) - objMargins.left,
                'margin-top': parseInt(layer.css('margin-top')) + objMargins.top
            });
        }
        if (lbotpos > wbotpos) {
            layer.css({
                'top': parseInt(ltoppos) - (lbotpos - wbotpos) - objMargins.top,
                'margin-left': parseInt(layer.css('margin-left')) + objMargins.left
            });
        }
        if (loffset.left < woffset.left) {
            layer.css({
                'left': parseInt(lleftpos) + (woffset.left - loffset.left) + objMargins.left,
                'margin-top': parseInt(layer.css('margin-top')) + objMargins.top
            });
        }
        if (loffset.top < woffset.top) {
            layer.css({
                'top': parseInt(ltoppos) + (woffset.top - loffset.top) + objMargins.top,
                'margin-left': parseInt(layer.css('margin-left')) + objMargins.left
            });
        }
    },
    HideFilter: function (objElement) {
        var myObjects = new Array();
        var master = $('#filterMasterLayer');
        myObjects.push($('.filWrap'));
        myObjects.push($('.filSelect'));
        myObjects.push($('.filContWrap'));
        myObjects.push(master);
        myObjects.push(objElement);
        for (i = 0; i < myObjects.length; i++) {
            if (myObjects[i].hasClass('filIsSel')) {
                myObjects[i].removeClass('filIsSel')
            }
            myObjects[i].removeAttr('style');
        }
        $('.activeFilter').removeClass('activeFilter').addClass('inActiveFilter');
    },
    SubmitFilter: function (objElement) {
        objElement.parent('form').submit();
        return false;
    },
    CheckboxSwitch: function (thisElement) {
        var thisName = thisElement.attr('name');
        $("input[name='" + thisName + "']").prop('checked', false);
        thisElement.prop('checked', true);
        return false;
    },
    CheckboxSingle: function (thisElement) {
        if (thisElement.prop('checked') == false) {
            thisElement.prop('checked', false);
            GeneralJS.DisablePriceSelect();
            return false;
        }
        var thisName = thisElement.attr('name');
        $("input[name='" + thisName + "']").prop('checked', false);
        thisElement.prop('checked', true);
        GeneralJS.DisablePriceSelect();
        return false;
    },
    DisablePriceSelect: function () {
        if ($('.preisInputCheckbox').prop('checked') == false) {
            $('#filpreisinput').attr('disabled', 'disabled');
        } else {
            $('#filpreisinput').removeAttr('disabled');
        }
    },
    ShowServiceLayer: function () {
        $('a#ServiceSelectLink').addClass('ServiceSelectLinkOver');
        $('div#ServiceSelectBox').css('left', '786px');
    },
    HideServiceLayer: function () {
        $('a#ServiceSelectLink').removeClass('ServiceSelectLinkOver');
        $('div#ServiceSelectBox').css('left', '-1000px');
    },
    getCBoxText: function (thisobj) {
        var rel = thisobj.attr('rel').split('|');
        if (rel[0] == 'null') {
            rel[0] = ' ';
        }
        if (rel[1] == 'null') {
            rel[1] = ' ';
        }
        return rel;
    },
    toggleformchk: function (objform) {
        var objlink = objform.find('.filSelAct a');
        if (objlink.length > 0) {
            var rel = GeneralJS.getCBoxText(objlink);
            objinputchk = objform.find('input:checked');
            if (objinputchk.length > 0) {
                objlink.html(rel[0]);
            } else {
                objlink.html(rel[1]);
            }
        }
    },
    ToggleCBoxControl: function (objId) {
        GeneralJS.toggleformchk($('#' + objId));
    },
    ShowId: function () {
        var args = GeneralJS.ShowId.arguments;
        for (y = 0; y < args.length; y++) {
            $('#' + args[y]).show();
        }
    },
    HideId: function () {
        var args = GeneralJS.HideId.arguments;
        for (y = 0; y < args.length; y++) {
            $('#' + args[y]).hide();
        }
    },
    SetStyle: function (objElement, thisstyle, thisvalue) {
        $(objElement).css(thisstyle, thisvalue);
    },
    ShowLayerId: function (objId) {
        $('.KCLayer').hide();
        $('#' + objId).show();
    },
    ToggleId: function () {
        var args = GeneralJS.ToggleId.arguments;
        for (y = 0; y < args.length; y++) {
            $('#' + args[y]).toggle();
        }
    },
    GoTo: function (url) {
        location.href = url;
    },
    switchPullUp: function (thisElement) {
        var thisPullUp = thisElement.parent();
        if (thisPullUp.hasClass('pullDown')) {
            thisPullUp.removeClass('pullDown');
        } else {
            thisPullUp.addClass('pullDown');
        }
    },
    switchPullUpAndRating: function (thisElement) {
        var thisPullUp = thisElement.parent('li');
        if (thisPullUp.hasClass('pullDown')) {
            thisPullUp.removeClass('pullDown');
            thisElement.children('.ratingCs').addClass('ratingGr').removeClass('ratingCs');
        } else {
            thisPullUp.addClass('pullDown');
            thisElement.children('.ratingGr').addClass('ratingCs').removeClass('ratingGr');
        }
    },
    FilterLinkOver: function (thisElement) {
        var FilterCategory = $(thisElement).attr('id');
        window.clearTimeout(TimeSettings[FilterCategory]);
        TimeSettings[FilterCategory] = window.setTimeout("$('#" + FilterCategory + "').addClass('FilterOver');", (MainnavigationTime));
    },
    FilterLinkOut: function (thisElement) {
        var FilterCategory = $(thisElement).attr('id');
        window.clearTimeout(TimeSettings[FilterCategory]);
        TimeSettings[FilterCategory] = window.setTimeout("$('#" + FilterCategory + "').removeClass('FilterOver');", (MainnavigationTime));
    },
    SelectCountry: function (thisElement) {
        $('.addresses').hide();
        $('.' + $(thisElement).attr('value')).show();
    },
    scrollToObj: function (objId) {
        $.scrollTo($(objId), 1000);
        return false;
    },
    ArticleBoxLink: function (thisElement) {
        targetId = $(thisElement).attr('OpenId');
        $('.ArticleNavi').children('div.TabActiv').attr('class', 'TabInActiv');
        $('.ArticleNavi').children('div.TabActivGelb').attr('class', 'TabInActivGelb');
        var thisobj = $(thisElement).parent();
        if (thisobj.hasClass('TabInActiv')) {
            thisobj.attr('class', 'TabActiv');
        } else if (thisobj.hasClass('TabInActivGelb')) {
            thisobj.attr('class', 'TabActivGelb');
        }
        $('.ArticleBoxWrapper').hide();
        $('#' + targetId).show();
        return false;
    },
    openAdsTab: function (thisElementID) {
        $('.ArticleNavi').children('div.TabActiv').attr('class', 'TabInActiv');
        $('.ArticleNavi').children('div.TabActivGelb').attr('class', 'TabInActivGelb');
        var thisobj = $('#ArtikelboxLink_' + thisElementID);
        if (thisobj.hasClass('TabInActiv')) {
            thisobj.attr('class', 'TabActiv');
        } else if (thisobj.hasClass('TabInActivGelb')) {
            thisobj.attr('class', 'TabActivGelb');
        }
        $('.ArticleBoxWrapper').hide();
        $('#' + thisElementID).show();
        return false;
    },
    toggleAllSlider: function (thisElement) {
        var action = $(thisElement).attr('action');
        var thisId = $(thisElement).attr('toogleSliderId');
        switch (action) {
            case 'open':
                $('ul#' + thisId).children('li').each(function () {
                    $(this).addClass('pullDown');
                });
                $(thisElement).attr('action', 'close');
                $(thisElement).children('span').html('<b>&raquo; ' + closeAll + '</b>');
                break;
            case 'close':
                $('ul#' + thisId).children('li').each(function () {
                    $(this).removeClass('pullDown');
                });
                $(thisElement).attr('action', 'open');
                $(thisElement).children('span').html('<b>&raquo; ' + expandAll + '</b>');
                break;
        }
        return false;
    },
    togglePullUp: function (objLink) {
        var rel = objLink.attr('rel').split('|');
        var status = objLink.html();
        var target = $('#' + rel[2]).children('li');
        if (status == rel[0]) {
            target.addClass('pullDown');
            objLink.html(rel[1]);
        } else {
            target.removeClass('pullDown');
            objLink.html(rel[0]);
        }
        return false;
    },
    toggleRatingSliders: function (thisElement) {
        var txt = $(thisElement).text();
        var rel = $(thisElement).attr('rel').split('|');
        var thisId = rel[2];
        var newText = rel[0];
        var oldText = rel[1];
        switch (txt) {
            case rel[0]:
                $('ul#' + thisId).children('li').each(function () {
                    $(this).addClass('pullDown');
                    var allSpans = $(this).find('span');
                    allSpans.each(function () {
                        if ($(this).hasClass('ratingGr')) {
                            $(this).addClass('ratingCs').removeClass('ratingGr');
                        }
                    });
                });
                $(thisElement).attr('action', 'close');
                $(thisElement).text(rel[1]);
                break;
            case rel[1]:
                $('ul#' + thisId).children('li').each(function () {
                    $(this).removeClass('pullDown');
                    var allSpans = $(this).find('span');
                    allSpans.each(function () {
                        if ($(this).hasClass('ratingCs')) {
                            $(this).addClass('ratingGr').removeClass('ratingCs');
                        }
                    });
                });
                $(thisElement).attr('action', 'open');
                $(thisElement).text(rel[0]);
                break;
        }
        return false;
    },
    InitProductCinema: function (thisElementID) {
        var objProductCinema = $('#' + thisElementID).children('div').children('div.Wrapper');
        var objProductCinemaStageWrapper = objProductCinema.children('.ProductCinemaStage').children('.Wrapper');
        var objProductCinemaContent = objProductCinemaStageWrapper.children('.ProductCinemaWrapper');
        var objProductCinemaArrowLeft = objProductCinema.children('div.ProductCinemaArrowLeft').children('a');
        var objProductCinemaArrowRight = objProductCinema.children('div.ProductCinemaArrowRight').children('a');
        var ProductCinemaStageWidth = parseInt(objProductCinema.children('.ProductCinemaStage').css('width'));
        var ProductCinemaCount = objProductCinemaContent.length;
        var ProductCinemaWrapperWidth = parseInt(objProductCinemaContent.css('width')) + parseInt(objProductCinemaContent.css('margin-right'));
        var ProductCinemaMaxWidth = ProductCinemaWrapperWidth * ProductCinemaCount;
        var intProductCinemaContentHeight = objProductCinemaStageWrapper.outerHeight();
        $('#' + thisElementID).css('height', objProductCinemaStageWrapper.outerHeight() + 'px');
        objProductCinemaStageWrapper.animate({
            left: '0px'
        }, 500);
        objProductCinemaArrowLeft.css('display', 'none');
        if (ProductCinemaMaxWidth > ProductCinemaStageWidth) {
            objProductCinemaArrowRight.css('display', 'block');
        }
        ProductCinemaMaxWidth = ProductCinemaMaxWidth - ProductCinemaStageWidth;
        objProductCinema.children('input.ProductCinemaStageWidth').attr('value', ProductCinemaStageWidth);
        objProductCinema.children('input.ProductCinemaWrapperWidth').attr('value', ProductCinemaWrapperWidth);
        objProductCinema.children('input.ProductCinemaMaxWidth').attr('value', ProductCinemaMaxWidth);
        objProductCinema.children('input.ProductCinemaPosition').attr('value', '0');
        var ProductCinemaPosition = parseInt(objProductCinemaStageWrapper.css('left'));
    },
    appendButtonFeatsId: function (thisElementID) {
        GeneralJS.appendButtonFeats($('#' + thisElementID));
    },
    appendButtonFeats: function (thisElement) {
        var objProductCinema = thisElement.children('div').children('div.Wrapper');
        var objProductCinemaStage = objProductCinema.children('.ProductCinemaStage');
        var objProductCinemaStageWrapper = objProductCinemaStage.children('.Wrapper');
        var objProductCinemaContent = objProductCinemaStageWrapper.children('.ProductCinemaWrapper');
        var objProductCinemaArrowLeft = objProductCinema.children('div.ProductCinemaArrowLeft').children('a');
        var objProductCinemaArrowRight = objProductCinema.children('div.ProductCinemaArrowRight').children('a');
        var intProductCinemaContentHeight = objProductCinemaStageWrapper.outerHeight();
        if (intProductCinemaContentHeight != null && intProductCinemaContentHeight != 0) {
            objProductCinemaStage.css('height', intProductCinemaContentHeight + 'px');
        }
        var ProductCinemaStageWidth = parseInt(objProductCinemaStage.css('width'));
        var ProductCinemaCount = 0;
        var switchCounter = 1;
        objProductCinemaStageWrapper.children().each(function () {
            if ($(this).hasClass('ClearBoth')) {
                switchCounter = 0;
            }
            if (switchCounter == 1 && $(this).hasClass('ProductCinemaWrapper')) {
                ProductCinemaCount++;
            }
        });
        var objProductCinemaContentMargin = parseInt(objProductCinemaContent.css('margin-right'));
        var ProductCinemaWrapperWidth = parseInt(objProductCinemaContent.css('width')) + objProductCinemaContentMargin;
        var ProductCinemaMaxWidth = ProductCinemaWrapperWidth * ProductCinemaCount;
        if ((ProductCinemaMaxWidth - objProductCinemaContentMargin) > ProductCinemaStageWidth) {
            objProductCinemaArrowRight.css('display', 'block');
        }
        ProductCinemaMaxWidth = ProductCinemaMaxWidth - ProductCinemaStageWidth;
        objProductCinema.children('input.ProductCinemaStageWidth').attr('value', ProductCinemaStageWidth);
        objProductCinema.children('input.ProductCinemaWrapperWidth').attr('value', ProductCinemaWrapperWidth);
        objProductCinema.children('input.ProductCinemaMaxWidth').attr('value', ProductCinemaMaxWidth);
        var ProductCinemaPosition = parseInt(objProductCinemaStageWrapper.css('left'));
        objProductCinemaArrowRight.click(function () {
            var objProductCinema = $(this).parent().parent();
            var objProductCinemaStageWrapper = objProductCinema.children('.ProductCinemaStage').children('.Wrapper');
            var objProductCinemaContent = objProductCinemaStageWrapper.children('.ProductCinemaWrapper');
            var objProductCinemaContent = objProductCinemaStageWrapper.children('.ProductCinemaWrapper');
            var objProductCinemaArrowLeft = objProductCinema.children('div.ProductCinemaArrowLeft').children('a');
            var objProductCinemaArrowRight = objProductCinema.children('div.ProductCinemaArrowRight').children('a');
            var objProductCinemaPosition = objProductCinema.children('input.ProductCinemaPosition');
            var ProductCinemaStageWidth = parseInt(objProductCinema.children('input.ProductCinemaStageWidth').attr('value'));
            var ProductCinemaWrapperWidth = parseInt(objProductCinema.children('input.ProductCinemaWrapperWidth').attr('value'));
            var ProductCinemaMaxWidth = parseInt(objProductCinema.children('input.ProductCinemaMaxWidth').attr('value'));
            var ProductCinemaPosition = parseInt(objProductCinemaPosition.attr('value'));
            var NewProductCinemaPosition = ProductCinemaPosition - ProductCinemaWrapperWidth;
            var CheckProductCinemaPosition = NewProductCinemaPosition + ProductCinemaMaxWidth;
            if (CheckProductCinemaPosition >= 0) {
                objProductCinemaPosition.attr('value', NewProductCinemaPosition);
                objProductCinemaStageWrapper.animate({
                    left: NewProductCinemaPosition + 'px'
                }, 500);
                var CheckProductCinemaPosition = CheckProductCinemaPosition - ProductCinemaWrapperWidth;
            }
            if (CheckProductCinemaPosition < 0) {
                $(this).css('display', 'none');
            }
            if (NewProductCinemaPosition < 0) {
                objProductCinemaArrowLeft.css('display', 'block');
            }
            return false;
        });
        objProductCinemaArrowLeft.click(function () {
            var objProductCinema = $(this).parent().parent();
            var objProductCinemaStageWrapper = objProductCinema.children('.ProductCinemaStage').children('.Wrapper');
            var objProductCinemaContent = objProductCinemaStageWrapper.children('.ProductCinemaWrapper');
            var objProductCinemaContent = objProductCinemaStageWrapper.children('.ProductCinemaWrapper');
            var objProductCinemaArrowLeft = objProductCinema.children('div.ProductCinemaArrowLeft').children('a');
            var objProductCinemaArrowRight = objProductCinema.children('div.ProductCinemaArrowRight').children('a');
            var objProductCinemaPosition = objProductCinema.children('input.ProductCinemaPosition');
            var ProductCinemaStageWidth = parseInt(objProductCinema.children('input.ProductCinemaStageWidth').attr('value'));
            var ProductCinemaWrapperWidth = parseInt(objProductCinema.children('input.ProductCinemaWrapperWidth').attr('value'));
            var ProductCinemaMaxWidth = parseInt(objProductCinema.children('input.ProductCinemaMaxWidth').attr('value'));
            var ProductCinemaPosition = parseInt(objProductCinemaPosition.attr('value'));
            var NewProductCinemaPosition = ProductCinemaPosition + ProductCinemaWrapperWidth;
            if (NewProductCinemaPosition <= 0) {
                objProductCinemaPosition.attr('value', NewProductCinemaPosition);
                objProductCinemaStageWrapper.animate({
                    left: NewProductCinemaPosition + 'px'
                }, 500);
            }
            var CheckProductCinemaPosition = NewProductCinemaPosition + ProductCinemaMaxWidth;
            if (CheckProductCinemaPosition > 0) {
                objProductCinemaArrowRight.css('display', 'block');
            }
            if (NewProductCinemaPosition < 0) {
                $(this).css('display', 'block');
            } else {
                $(this).css('display', 'none');
            }
            return false;
        });
    },
    initCarruselId: function (thisElementID) {
        GeneralJS.initCarrusel($('#' + thisElementID));
    },
    initCarrusel: function (thisElement) {
        var ImgCarruselStageHeight = 0;
        var ImgCarruselWrapper = thisElement.children().children('.Wrapper');
        var ImgCarruselStage = ImgCarruselWrapper.children('.ImgCarruselStage');
        var ImgCarruselStageWrapper = ImgCarruselStage.children();
        var ImgCarruselStageWrapperId = ImgCarruselStageWrapper.attr('id');
        window.clearTimeout(TimeSettings[ImgCarruselStageWrapperId]);
        ImgCarruselStageWrapper.attr('left', '0px');
        var ImgCarruselArrowLeft = ImgCarruselWrapper.children('div.ImgCarruselArrowLeft');
        var ImgCarruselArrowRight = ImgCarruselWrapper.children('div.ImgCarruselArrowRight');
        var arrAllElemetsWidth = new Array();
        var intAllElemetsWidth = 0;
        var intLastElementWidth = 0;
        ImgCarruselStageWrapper.children('.LinkCarruselStage').each(function () {
            var thisWidth = $(this).outerWidth() + parseInt($(this).css('margin-right'));
            intLastElementWidth = thisWidth;
            var thisHeight = $(this).outerHeight();
            if (thisHeight > ImgCarruselStageHeight) {
                ImgCarruselStageHeight = thisHeight;
            }
            arrAllElemetsWidth.push(thisWidth);
            intAllElemetsWidth = intAllElemetsWidth + thisWidth;
        })
        var intLastElementPos = 0 - intAllElemetsWidth + intLastElementWidth;
        ImgCarruselStage.css('height', ImgCarruselStageHeight + 'px');
        ImgCarruselWrapper.css('height', ImgCarruselStageHeight + 'px');
        TimeSettings[ImgCarruselStageWrapperId] = window.setTimeout("GeneralJS.moveCarrusel('" + ImgCarruselStageWrapperId + "'," + intAllElemetsWidth + ",false);", 1000);
        thisElement.hover(function () {
            window.clearTimeout(TimeSettings[ImgCarruselStageWrapperId]);
        }, function () {
            TimeSettings[ImgCarruselStageWrapperId] = window.setTimeout("GeneralJS.moveCarrusel('" + ImgCarruselStageWrapperId + "'," + intAllElemetsWidth + ",false);", 1000);
        });
        ImgCarruselArrowLeft.click(function () {
            var curPos = parseInt($('#' + ImgCarruselStageWrapperId).css('left'));
            var chkPos = curPos;
            var newPos = 0;
            for (x = 0; x < arrAllElemetsWidth.length; x++) {
                curPos = curPos + arrAllElemetsWidth[x];
                if (curPos < 0) {
                    newPos = newPos - arrAllElemetsWidth[x];
                } else {
                    break;
                }
            }
            if (chkPos == 0) {
                newPos = intLastElementPos;
            }
            $('#' + ImgCarruselStageWrapperId).css('left', newPos + 'px');
        })
        ImgCarruselArrowRight.click(function () {
            var curPos = parseInt($('#' + ImgCarruselStageWrapperId).css('left'));
            var newPos = 0;
            for (x = 0; x < arrAllElemetsWidth.length; x++) {
                newPos = newPos - arrAllElemetsWidth[x];
                if (newPos < curPos) {
                    break;
                }
            }
            if ((newPos + intAllElemetsWidth) <= 0) {
                newPos = 0;
            }
            $('#' + ImgCarruselStageWrapperId).css('left', newPos + 'px');
        })
        var strDoubleContent = ImgCarruselStageWrapper.html();
        ImgCarruselStageWrapper.append(strDoubleContent);
    },
    moveCarrusel: function (ImgCarruselStageWrapperId, maxPos, curPos) {
        var imgsize = 133;
        var objThisCarrusel = $('#' + ImgCarruselStageWrapperId);
        if (!curPos) {
            var curPos = parseInt(objThisCarrusel.css('left'));
        }
        curPos = curPos - imgsize;
        if ((maxPos + curPos) < 0) {
            curPos = 0;
            objThisCarrusel.css('left', curPos + 'px');
            curPos = curPos - imgsize;
        }
        objThisCarrusel.animate({
            left: curPos
        }, 750);
        TimeSettings[ImgCarruselStageWrapperId] = window.setTimeout("GeneralJS.moveCarrusel('" + ImgCarruselStageWrapperId + "'," + maxPos + "," + curPos + ");", 2000);
    },
    StarsOver: function (thisElement) {
        $('#StarsImage').attr('src', $(thisElement).attr('image'));
        $('#StarsText').html($(thisElement).attr('text'));
    },
    StarsOut: function (thisElement) {
        $('#StarsImage').attr('src', $('#StarsInput').attr('image'));
        $('#StarsText').html($('#StarsInput').attr('text'));
    },
    StarsSet: function (thisElement) {
        $('#StarsInput').attr('image', $(thisElement).attr('image'));
        $('#StarsInput').attr('text', $(thisElement).attr('text'));
        $('#StarsInput').attr('value', $(thisElement).attr('value'));
        $('#StarsImage').attr('src', $(thisElement).attr('image'));
        $('#StarsText').html($(thisElement).attr('text'));
    },
    AttrSet: function (thisID, thisAttr, thisValue) {
        $('#' + thisID).attr(thisAttr, thisValue);
        return false;
    },
    ActiveClassSet: function (thisObject, thisElement) {
        $(thisObject).removeClass('Active');
        $(thisElement).addClass('Active');
        return false;
    },
    OpenShadowboxIframe: function (thisElement) {
        var strLink = $(thisElement).attr('href');
        var strTitle = $(thisElement).attr('title');
        var strheight = $(thisElement).attr('boxheight');
        var strwidth = $(thisElement).attr('boxwidth');
        Shadowbox.open({
            content: strLink,
            player: "iframe",
            title: strTitle,
            height: strheight,
            width: strwidth
        });
        return false;
    },
    initImgSwitcherId: function (thisElementID) {
        GeneralJS.initImgSwitcher($('#' + thisElementID));
    },
    initImgSwitcher: function (thisElement) {
        var ImgSwitchTargetLink = thisElement.children('a.ImgSwitchTarget');
        var ImgSwitchTargetImg = ImgSwitchTargetLink.children('img');
        var ImgSwitchLink = thisElement.children('a.ImgSwitch');
        ImgSwitchLink.each(function () {
            $(this).hover(function () {
                $(this).children('img').attr('src', $(this).attr('active'));
            }, function () {
                var strNewImg = $(this).attr('off');
                if (ImgSwitchTargetLink.attr('active') == $(this).attr('id')) {
                    strNewImg = $(this).attr('active');
                }
                $(this).children('img').attr('src', strNewImg);
            });
            $(this).click(function () {
                var thisId = $(this).attr('id');
                ImgSwitchTargetLink.attr('active', thisId);
                ImgSwitchTargetLink.attr('href', $(this).attr('href'));
                ImgSwitchTargetLink.attr('title', $(this).attr('title'));
                ImgSwitchTargetImg.attr('src', $(this).attr('src'));
                ImgSwitchLink.each(function () {
                    if (thisId != $(this).attr('id')) {
                        $(this).children('img').attr('src', $(this).attr('off'));
                    }
                })
                return false;
            });
        });
    },
    helpersnavigation: function (thisElementID) {
        $('li#' + thisElementID).addClass('pullDown');
        GeneralJS.scrollToObj('li#' + thisElementID);
    },
    initConversionTeaserId: function (thisElementID) {
        GeneralJS.initConversionTeaser($('#' + thisElementID));
    },
    initConversionTeaser: function (thisElement) {
        var A = false,
            imgSize = 767,
            ConversionTeaser = false,
            objWrapper = thisElement.children('.Wrapper'),
            objImgWrapper = objWrapper.children('.ImgWrapper'),
            objImgWrapperImages = objImgWrapper.children(),
            objLinkLeft = objWrapper.children('a.Left'),
            objLinkRight = objWrapper.children('a.Right'),
            objNavigation = objWrapper.children('.Navigation'),
            objNavigationLink = objNavigation.children('a'),
            intElementsLength = objImgWrapperImages.length * imgSize,
            intStartPos = 0 - intElementsLength,
            intFirstPos = intStartPos,
            intLastPos, intCurKey = 0,
            intImgWrapperImagesLenght = -1,
            arrImgWrapperImages = new Array();
        arrImgWrapperImages.push(intStartPos);
        objImgWrapperImages.each(function () {
            intImgWrapperImagesLenght++;
            intLastPos = intStartPos;
            intStartPos = intStartPos - imgSize;
            arrImgWrapperImages.push(intStartPos);
        });
        var thisHTML = objImgWrapper.html();
        thisHTML += thisHTML;
        objImgWrapper.append(thisHTML);
        objImgWrapper.css('left', arrImgWrapperImages[0] + 'px');
        ConversionTeaser = true;
        objLinkLeft.click(function () {
            if (!A && ConversionTeaser) {
                A = true;
                var cP = arrImgWrapperImages[intCurKey];
                cP = cP + imgSize;
                intCurKey--;
                if (intCurKey < 0) {
                    intCurKey = intImgWrapperImagesLenght;
                }
                objNavigationLink.each(function () {
                    if ($(this).attr('imagekey') == intCurKey) {
                        $(this).children('img').attr('src', $(this).attr('activ'));
                    } else {
                        $(this).children('img').attr('src', $(this).attr('offline'));
                    }
                });
                objImgWrapper.animate({
                    left: cP + 'px'
                }, 300, function () {
                    if (cP > intFirstPos) {
                        objImgWrapper.css('left', intLastPos + 'px')
                    }
                    A = false;
                });
            } else {
                return
            }
        });
        objLinkRight.click(function () {
            if (!A && ConversionTeaser) {
                A = true;
                var cP = arrImgWrapperImages[intCurKey];
                cP = cP - imgSize;
                intCurKey++;
                if (intCurKey > intImgWrapperImagesLenght) {
                    intCurKey = 0;
                }
                objNavigationLink.each(function () {
                    if ($(this).attr('imagekey') == intCurKey) {
                        $(this).children('img').attr('src', $(this).attr('activ'));
                    } else {
                        $(this).children('img').attr('src', $(this).attr('offline'));
                    }
                });
                objImgWrapper.animate({
                    left: cP + 'px'
                }, 300, function () {
                    if (cP < intLastPos) {
                        objImgWrapper.css('left', intFirstPos + 'px')
                    }
                    A = false;
                });
            } else {
                return
            }
        });
        objNavigationLink.click(function () {
            if (!A && ConversionTeaser) {
                A = true;
                intCurKey = $(this).attr('imagekey');
                objNavigationLink.each(function () {
                    if ($(this).attr('imagekey') == intCurKey) {
                        $(this).children('img').attr('src', $(this).attr('activ'));
                    } else {
                        $(this).children('img').attr('src', $(this).attr('offline'));
                    }
                });
                objImgWrapper.animate({
                    left: arrImgWrapperImages[intCurKey] + 'px'
                }, 300, function () {
                    A = false;
                });
            } else {
                return
            }
        });
    },
    initStyleEditor: function (arrStylesObjects, intStartKey) {
        var arrStyles = arrStylesObjects;
        var StyleEditorCinemaStage = $('#StyleEditorCinemaStage');
        var StyleEditorCinemaStageWrapper = StyleEditorCinemaStage.children('.Wrapper');
        var strSECSWHTML = '';
        var intObjPosition = 125;
        var intMaxPosition = arrStyles.length - 1;
        var intSetPosition = intStartKey;
        for (x = 0; x < arrStyles.length; x++) {
            if (intObjPosition > 0) {
                intInsertPosition = 0 - intMaxPosition * 125;
            } else {
                intInsertPosition = intObjPosition;
            }
            arrStyles[x]['position'] = intInsertPosition;
            intObjPosition = intObjPosition - 125;
            strSECSWHTML += '<div class="StyleEditorCinemaWrapper">' + '<div class="Wrapper">' + '<img src="' + arrStyles[x]['thumb'] + '"></a>' + '</div>' + '</div>';
        }
        strSECSWHTML += strSECSWHTML;
        StyleEditorCinemaStageWrapper.html(strSECSWHTML);
        $('#SECSWrapper').css('left', arrStyles[intSetPosition]['position'] + 'px');
        GeneralJS.setStyleEditor(arrStyles[intSetPosition]);
        $('#SELeft').click(function () {
            intSetPosition--;
            if (intSetPosition < 0) {
                intSetPosition = intMaxPosition;
            }
            var intNextPos = parseInt($('#SECSWrapper').css('left')) + 125;
            $('#SECSWrapper').animate({
                left: intNextPos + 'px'
            }, 100, function () {
                $('#SECSWrapper').css('left', arrStyles[intSetPosition]['position'] + 'px');
            });
            GeneralJS.setStyleEditor(arrStyles[intSetPosition]);
        });
        $('#SERight').click(function () {
            intSetPosition++;
            if (intSetPosition > intMaxPosition) {
                intSetPosition = 0;
            }
            var intNextPos = parseInt($('#SECSWrapper').css('left')) - 125;
            $('#SECSWrapper').animate({
                left: intNextPos + 'px'
            }, 100, function () {
                $('#SECSWrapper').css('left', arrStyles[intSetPosition]['position'] + 'px');
            });
            GeneralJS.setStyleEditor(arrStyles[intSetPosition]);
        });
    },
    setStyleEditor: function (objStyle) {
        $('#SEDetailLink').attr('href', objStyle['linkdetail']);
        $('#SEDetailImg').attr('src', objStyle['detailimg']);
        $('#SEDetailImg').attr('title', objStyle['stylename']);
        $('#SEProductName').html(objStyle['stylename']);
        $('#SEPrice').html(objStyle['price']);
        $('#SEShopingcard').attr('href', objStyle['linkshoppingcard']);
        $('#SERecomment').attr('href', objStyle['linkrecomment']);
        $('#SEDetail').attr('href', objStyle['linkdetail']);
    },
    initHalfTeaserId: function (thisElementID) {
        GeneralJS.initHalfTeaser($('#' + thisElementID));
    },
    initHalfTeaser: function (objElement) {
        objElement.children('.halfteaserover').children('img').mouseover(function () {
            var targetid = $(this).attr('thisid');
            $(this).parent().hide();
            $(this).parent().parent().children('.' + targetid).show();
        });
        objElement.children('.halfteaserout').mouseout(function () {
            $(this).hide();
            $(this).parent().children('div.halfteaserover').show();
        });
    },
    gsswitcher: function (thisContentID, thisFooterID) {
        $('.GSCont').css('display', 'none');
        $('#' + thisContentID).css('display', 'block');
        Shadowbox.setFooter(GeneralJS.strgethtml(thisFooterID));
    },
    strgethtml: function (thisElementID) {
        var thishtml = $("#" + thisElementID).html();
        return thishtml;
    },
    openPanel: function (url, title, x, y) {
        if (x == null && y == null) {
            x = 300;
            y = 300;
        }
        Shadowbox.open({
            content: '<div id="shadowboxMsg"></div>',
            player: "html",
            title: title,
            height: y,
            width: x,
            options: {
                onFinish: function () {
                    $.get(url, function (strHtml) {
                        $("#shadowboxMsg").append(strHtml);
                    });
                },
                enableKeys: false
            }
        });
    },
    openL2: function (url, x, y, objthis, mouseaction, addOffset) {
        var objLayer = $('#adsLayer');
        var wsctop = $(window).scrollTop();
        var viewmax = $(window).height() + wsctop;
        var viewwidth = $(window).width();
        objLayer.css('visibility', 'hidden');
        objLayer.css('display', 'block');
        thisobj = $(objthis);
        var pos = thisobj.offset();
        var lpos = pos.left + thisobj.outerWidth() + 15;
        var tpos = pos.top;
        objLayer.css('top', '0px');
        objLayer.css('left', '0px');
        $.get(url, function (innerhtml) {
            tpos = pos.top;
            $('#adsLinner').html('');
            $('#adsLinner').html(innerhtml);
            adsLayerContent = objLayer.find('.adsLayerContent');
            ardLayerWidth = parseInt($(adsLayerContent).width()) + 86;
            if (isNaN(ardLayerWidth)) {
                ardLayerWidth = 1000;
            }
            objLayer.css('width', ardLayerWidth + 'px');
            objHeight = objLayer.height();
            var viewreal = pos.top + objHeight;
            if (viewreal > viewmax) {
                newpos = pos.top - objHeight + 40;
                if (newpos < (wsctop + 5)) {
                    newpos = wsctop + 5;
                }
                tpos = newpos;
            }
            objWidth = objLayer.width();
            viewreal = lpos + objWidth;
            if (viewreal > viewwidth) {
                newpos = pos.left - objWidth;
                if (newpos < 5) {
                    newpos = 5;
                }
                lpos = newpos;
            }
            objLayer.css('top', tpos + 'px');
            objLayer.css('left', lpos + 'px');
            GeneralJS.checkBoundaries(objLayer, $('#Website'), {
                left: 15
            });
            objLayer.css('visibility', 'visible');
        });
        if (mouseaction != undefined) {
            if (mouseaction == true) {
                $('#adsLinner').mouseenter(function () {
                    $('#adsLayer').mouseleave(function () {
                        $('#adsLinner').unbind('mouseenter');
                        $('#adsLayer').unbind('mouseleave');
                        GeneralJS.closeL2($(this));
                    });
                });
            }
        }
        if (addOffset != undefined) {
            var top = 0;
            var left = 0;
            if (addOffset.top != undefined) {
                tpos += addOffset.top;
            }
            if (addOffset.left != undefined) {
                lpos += addOffset.left;
            }
            objLayer.css('top', tpos + 'px');
            objLayer.css('left', lpos + 'px');
        }
        GeneralJS.checkBoundaries(objLayer, $('#Website'), {
            left: 15
        });
        $('#filterOverlay').css({
            display: 'block',
            'background-color': 'transparent',
            'z-index': 399,
            width: $(document).width(),
            height: $(document).height()
        }).one('click', function () {
            GeneralJS.closeL2();
            return false;
        });
        return false;
    },
    closeL2: function () {
        $('#adsLayer').css('display', 'none');
        $('#adsLinner').html('');
        $('#filterOverlay').removeAttr('style');
        return false;
    },
    toggleJigTxt: function (thisElement) {
        var parent = thisElement.parents('.jigTxt');
        var rel = thisElement.attr('rel');
        var text = thisElement.text();
        var hiddenCont = parent.find('.jigTxt2');
        var br = $('.break');
        if (parent.hasClass('js_closed')) {
            hiddenCont.addClass('shown').removeClass('hidden');
            parent.removeClass('js_closed');
            br.css('display', 'block');
        } else {
            hiddenCont.addClass('hidden').removeClass('shown');
            parent.addClass('js_closed');
            br.css('display', 'inline');
        }
        thisElement.text(rel);
        thisElement.attr('rel', text);
        return false;
    },
    initvftid: function (thisElementID) {
        GeneralJS.initvft($('#' + thisElementID));
    },
    initvft: function (objElement) {
        var thisElementID = objElement.attr('id');
        objElement.children('a.' + thisElementID + 'sub').hover(function () {
            var thisLink = $(this);
            var thisLinkId = thisLink.attr('id');
            window.clearTimeout(TimeSettings[thisElementID]);
            TimeSettings[thisElementID] = window.setTimeout("GeneralJS.togglevft('" + thisElementID + "','" + thisLinkId + "');", MainnavigationTime);
        }, function () {
            window.clearTimeout(TimeSettings[thisElementID]);
        });
    },
    togglevft: function (thisElementID, thisLinkId) {
        objElement = $('#' + thisElementID);
        thisLink = $('#' + thisLinkId);
        objElement.children('img').css('visibility', 'hidden');
        objElement.children('img#i' + thisLinkId).css('visibility', 'visible');
        $('#' + thisElementID + 'main').attr('href', thisLink.attr('href'));
    },
    togglefsContent: function () {
        $('#filterInnerWrap .js_fstoggle, #LeftNavigation .js_fstoggle').each(function () {
            var objToggle = $(this);
            var objContent = objToggle.siblings('.js_fscontent');
            var objArrow = objToggle.children('a.toggle');
            objToggle.click(function () {
                if (objContent.hasClass('hide')) {
                    objContent.removeClass('hide');
                    objArrow.removeClass('up');
                    objArrow.addClass('down');
                } else {
                    objContent.addClass('hide');
                    objArrow.removeClass('down');
                    objArrow.addClass('up');
                }
            });
        });
    },
    openWindow: function (strUrl, x, y) {
        if (x == null && y == null) {
            x = 300;
            y = 300;
        }
        thisWindow = window.open(strUrl, 'OpenedWindow', 'width=' + x + ',height=' + y + ',left=100,top=200,location=no,menubar=no,resizable=no,scrollbars=yes,status=no');
        thisWindow.focus();
    },
    scrollbarReinit: function (aktObj) {
        var scrollApi = aktObj.find('.js_scrollBar').data('jsp');
        if (scrollApi != undefined) {
            scrollApi.reinitialise();
        }
    }
};
Shadowbox.init({
    players: ["html", "iframe"]
});;
(function ($) {
    var types = ['DOMMouseScroll', 'mousewheel'];
    if ($.event.fixHooks) {
        for (var i = types.length; i;) {
            $.event.fixHooks[types[--i]] = $.event.mouseHooks;
        }
    }
    $.event.special.mousewheel = {
        setup: function () {
            if (this.addEventListener) {
                for (var i = types.length; i;) {
                    this.addEventListener(types[--i], handler, false);
                }
            } else {
                this.onmousewheel = handler;
            }
        },
        teardown: function () {
            if (this.removeEventListener) {
                for (var i = types.length; i;) {
                    this.removeEventListener(types[--i], handler, false);
                }
            } else {
                this.onmousewheel = null;
            }
        }
    };
    $.fn.extend({
        mousewheel: function (fn) {
            return fn ? this.bind("mousewheel", fn) : this.trigger("mousewheel");
        },
        unmousewheel: function (fn) {
            return this.unbind("mousewheel", fn);
        }
    });

    function handler(event) {
        var orgEvent = event || window.event,
            args = [].slice.call(arguments, 1),
            delta = 0,
            returnValue = true,
            deltaX = 0,
            deltaY = 0;
        event = $.event.fix(orgEvent);
        event.type = "mousewheel";
        if (orgEvent.wheelDelta) {
            delta = orgEvent.wheelDelta / 120;
        }
        if (orgEvent.detail) {
            delta = -orgEvent.detail / 3;
        }
        deltaY = delta;
        if (orgEvent.axis !== undefined && orgEvent.axis === orgEvent.HORIZONTAL_AXIS) {
            deltaY = 0;
            deltaX = -1 * delta;
        }
        if (orgEvent.wheelDeltaY !== undefined) {
            deltaY = orgEvent.wheelDeltaY / 120;
        }
        if (orgEvent.wheelDeltaX !== undefined) {
            deltaX = -1 * orgEvent.wheelDeltaX / 120;
        }
        args.unshift(event, delta, deltaX, deltaY);
        return ($.event.dispatch || $.event.handle).apply(this, args);
    }
})(jQuery);;
(function ($) {
    var mwheelI = {
        pos: [-260, -260]
    }, minDif = 3,
        doc = document,
        root = doc.documentElement,
        body = doc.body,
        longDelay, shortDelay;

    function unsetPos() {
        if (this === mwheelI.elem) {
            mwheelI.pos = [-260, -260];
            mwheelI.elem = false;
            minDif = 3;
        }
    }
    $.event.special.mwheelIntent = {
        setup: function () {
            var jElm = $(this).bind('mousewheel', $.event.special.mwheelIntent.handler);
            if (this !== doc && this !== root && this !== body) {
                jElm.bind('mouseleave', unsetPos);
            }
            jElm = null;
            return true;
        },
        teardown: function () {
            $(this).unbind('mousewheel', $.event.special.mwheelIntent.handler).unbind('mouseleave', unsetPos);
            return true;
        },
        handler: function (e, d) {
            var pos = [e.clientX, e.clientY];
            if (this === mwheelI.elem || Math.abs(mwheelI.pos[0] - pos[0]) > minDif || Math.abs(mwheelI.pos[1] - pos[1]) > minDif) {
                mwheelI.elem = this;
                mwheelI.pos = pos;
                minDif = 250;
                clearTimeout(shortDelay);
                shortDelay = setTimeout(function () {
                    minDif = 10;
                }, 200);
                clearTimeout(longDelay);
                longDelay = setTimeout(function () {
                    minDif = 3;
                }, 1500);
                e = $.extend({}, e, {
                    type: 'mwheelIntent'
                });
                return $.event.handle.apply(this, arguments);
            }
        }
    };
    $.fn.extend({
        mwheelIntent: function (fn) {
            return fn ? this.bind("mwheelIntent", fn) : this.trigger("mwheelIntent");
        },
        unmwheelIntent: function (fn) {
            return this.unbind("mwheelIntent", fn);
        }
    });
    $(function () {
        body = doc.body;
        $(doc).bind('mwheelIntent.mwheelIntentDefault', $.noop);
    });
})(jQuery);;
(function (b, a, c) {
    b.fn.jScrollPane = function (e) {
        function d(D, O) {
            var ay, Q = this,
                Y, aj, v, al, T, Z, y, q, az, aE, au, i, I, h, j, aa, U, ap, X, t, A, aq, af, am, G, l, at, ax, x, av, aH, f, L, ai = true,
                P = true,
                aG = false,
                k = false,
                ao = D.clone(false, false).empty(),
                ac = b.fn.mwheelIntent ? "mwheelIntent.jsp" : "mousewheel.jsp";
            aH = D.css("paddingTop") + " " + D.css("paddingRight") + " " + D.css("paddingBottom") + " " + D.css("paddingLeft");
            f = (parseInt(D.css("paddingLeft"), 10) || 0) + (parseInt(D.css("paddingRight"), 10) || 0);

            function ar(aQ) {
                var aL, aN, aM, aJ, aI, aP, aO = false,
                    aK = false;
                ay = aQ;
                if (Y === c) {
                    aI = D.scrollTop();
                    aP = D.scrollLeft();
                    D.css({
                        overflow: "hidden",
                        padding: 0
                    });
                    aj = D.innerWidth() + f;
                    v = D.innerHeight();
                    D.width(aj);
                    Y = b('<div class="jspPane" />').css("padding", aH).append(D.children());
                    al = b('<div class="jspContainer" />').css({
                        width: aj + "px",
                        height: v + "px"
                    }).append(Y).appendTo(D)
                } else {
                    D.css("width", "");
                    aO = ay.stickToBottom && K();
                    aK = ay.stickToRight && B();
                    aJ = D.innerWidth() + f != aj || D.outerHeight() != v;
                    if (aJ) {
                        aj = D.innerWidth() + f;
                        v = D.innerHeight();
                        al.css({
                            width: aj + "px",
                            height: v + "px"
                        })
                    }
                    if (!aJ && L == T && Y.outerHeight() == Z) {
                        D.width(aj);
                        return
                    }
                    L = T;
                    Y.css("width", "");
                    D.width(aj);
                    al.find(">.jspVerticalBar,>.jspHorizontalBar").remove().end()
                }
                Y.css("overflow", "auto");
                if (aQ.contentWidth) {
                    T = aQ.contentWidth
                } else {
                    T = Y[0].scrollWidth
                }
                Z = Y[0].scrollHeight;
                Y.css("overflow", "");
                y = T / aj;
                q = Z / v;
                az = q > 1;
                aE = y > 1;
                if (!(aE || az)) {
                    D.removeClass("jspScrollable");
                    Y.css({
                        top: 0,
                        width: al.width() - f
                    });
                    n();
                    E();
                    R();
                    w()
                } else {
                    D.addClass("jspScrollable");
                    aL = ay.maintainPosition && (I || aa);
                    if (aL) {
                        aN = aC();
                        aM = aA()
                    }
                    aF();
                    z();
                    F();
                    if (aL) {
                        N(aK ? (T - aj) : aN, false);
                        M(aO ? (Z - v) : aM, false)
                    }
                    J();
                    ag();
                    an();
                    if (ay.enableKeyboardNavigation) {
                        S()
                    }
                    if (ay.clickOnTrack) {
                        p()
                    }
                    C();
                    if (ay.hijackInternalLinks) {
                        m()
                    }
                } if (ay.autoReinitialise && !av) {
                    av = setInterval(function () {
                        ar(ay)
                    }, ay.autoReinitialiseDelay)
                } else {
                    if (!ay.autoReinitialise && av) {
                        clearInterval(av)
                    }
                }
                aI && D.scrollTop(0) && M(aI, false);
                aP && D.scrollLeft(0) && N(aP, false);
                D.trigger("jsp-initialised", [aE || az])
            }
            function aF() {
                if (az) {
                    al.append(b('<div class="jspVerticalBar" />').append(b('<div class="jspCap jspCapTop" />'), b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragTop" />'), b('<div class="jspDragBottom" />'))), b('<div class="jspCap jspCapBottom" />')));
                    U = al.find(">.jspVerticalBar");
                    ap = U.find(">.jspTrack");
                    au = ap.find(">.jspDrag");
                    if (ay.showArrows) {
                        aq = b('<a class="jspArrow jspArrowUp" />').bind("mousedown.jsp", aD(0, -1)).bind("click.jsp", aB);
                        af = b('<a class="jspArrow jspArrowDown" />').bind("mousedown.jsp", aD(0, 1)).bind("click.jsp", aB);
                        if (ay.arrowScrollOnHover) {
                            aq.bind("mouseover.jsp", aD(0, -1, aq));
                            af.bind("mouseover.jsp", aD(0, 1, af))
                        }
                        ak(ap, ay.verticalArrowPositions, aq, af)
                    }
                    t = v;
                    al.find(">.jspVerticalBar>.jspCap:visible,>.jspVerticalBar>.jspArrow").each(function () {
                        t -= b(this).outerHeight()
                    });
                    au.hover(function () {
                        au.addClass("jspHover")
                    }, function () {
                        au.removeClass("jspHover")
                    }).bind("mousedown.jsp", function (aI) {
                        b("html").bind("dragstart.jsp selectstart.jsp", aB);
                        au.addClass("jspActive");
                        var s = aI.pageY - au.position().top;
                        b("html").bind("mousemove.jsp", function (aJ) {
                            V(aJ.pageY - s, false)
                        }).bind("mouseup.jsp mouseleave.jsp", aw);
                        return false
                    });
                    o()
                }
            }
            function o() {
                ap.height(t + "px");
                I = 0;
                X = ay.verticalGutter + ap.outerWidth();
                Y.width(aj - X - f);
                try {
                    if (U.position().left === 0) {
                        Y.css("margin-left", X + "px")
                    }
                } catch (s) {}
            }
            function z() {
                if (aE) {
                    al.append(b('<div class="jspHorizontalBar" />').append(b('<div class="jspCap jspCapLeft" />'), b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragLeft" />'), b('<div class="jspDragRight" />'))), b('<div class="jspCap jspCapRight" />')));
                    am = al.find(">.jspHorizontalBar");
                    G = am.find(">.jspTrack");
                    h = G.find(">.jspDrag");
                    if (ay.showArrows) {
                        ax = b('<a class="jspArrow jspArrowLeft" />').bind("mousedown.jsp", aD(-1, 0)).bind("click.jsp", aB);
                        x = b('<a class="jspArrow jspArrowRight" />').bind("mousedown.jsp", aD(1, 0)).bind("click.jsp", aB);
                        if (ay.arrowScrollOnHover) {
                            ax.bind("mouseover.jsp", aD(-1, 0, ax));
                            x.bind("mouseover.jsp", aD(1, 0, x))
                        }
                        ak(G, ay.horizontalArrowPositions, ax, x)
                    }
                    h.hover(function () {
                        h.addClass("jspHover")
                    }, function () {
                        h.removeClass("jspHover")
                    }).bind("mousedown.jsp", function (aI) {
                        b("html").bind("dragstart.jsp selectstart.jsp", aB);
                        h.addClass("jspActive");
                        var s = aI.pageX - h.position().left;
                        b("html").bind("mousemove.jsp", function (aJ) {
                            W(aJ.pageX - s, false)
                        }).bind("mouseup.jsp mouseleave.jsp", aw);
                        return false
                    });
                    l = al.innerWidth();
                    ah()
                }
            }
            function ah() {
                al.find(">.jspHorizontalBar>.jspCap:visible,>.jspHorizontalBar>.jspArrow").each(function () {
                    l -= b(this).outerWidth()
                });
                G.width(l + "px");
                aa = 0
            }
            function F() {
                if (aE && az) {
                    var aI = G.outerHeight(),
                        s = ap.outerWidth();
                    t -= aI;
                    b(am).find(">.jspCap:visible,>.jspArrow").each(function () {
                        l += b(this).outerWidth()
                    });
                    l -= s;
                    v -= s;
                    aj -= aI;
                    G.parent().append(b('<div class="jspCorner" />').css("width", aI + "px"));
                    o();
                    ah()
                }
                if (aE) {
                    Y.width((al.outerWidth() - f) + "px")
                }
                Z = Y.outerHeight();
                q = Z / v;
                if (aE) {
                    at = Math.ceil(1 / y * l);
                    if (at > ay.horizontalDragMaxWidth) {
                        at = ay.horizontalDragMaxWidth
                    } else {
                        if (at < ay.horizontalDragMinWidth) {
                            at = ay.horizontalDragMinWidth
                        }
                    }
                    h.width(at + "px");
                    j = l - at;
                    ae(aa)
                }
                if (az) {
                    A = Math.ceil(1 / q * t);
                    if (A > ay.verticalDragMaxHeight) {
                        A = ay.verticalDragMaxHeight
                    } else {
                        if (A < ay.verticalDragMinHeight) {
                            A = ay.verticalDragMinHeight
                        }
                    }
                    au.height(A + "px");
                    i = t - A;
                    ad(I)
                }
            }
            function ak(aJ, aL, aI, s) {
                var aN = "before",
                    aK = "after",
                    aM;
                if (aL == "os") {
                    aL = /Mac/.test(navigator.platform) ? "after" : "split"
                }
                if (aL == aN) {
                    aK = aL
                } else {
                    if (aL == aK) {
                        aN = aL;
                        aM = aI;
                        aI = s;
                        s = aM
                    }
                }
                aJ[aN](aI)[aK](s)
            }
            function aD(aI, s, aJ) {
                return function () {
                    H(aI, s, this, aJ);
                    this.blur();
                    return false
                }
            }
            function H(aL, aK, aO, aN) {
                aO = b(aO).addClass("jspActive");
                var aM, aJ, aI = true,
                    s = function () {
                        if (aL !== 0) {
                            Q.scrollByX(aL * ay.arrowButtonSpeed)
                        }
                        if (aK !== 0) {
                            Q.scrollByY(aK * ay.arrowButtonSpeed)
                        }
                        aJ = setTimeout(s, aI ? ay.initialDelay : ay.arrowRepeatFreq);
                        aI = false
                    };
                s();
                aM = aN ? "mouseout.jsp" : "mouseup.jsp";
                aN = aN || b("html");
                aN.bind(aM, function () {
                    aO.removeClass("jspActive");
                    aJ && clearTimeout(aJ);
                    aJ = null;
                    aN.unbind(aM)
                })
            }
            function p() {
                w();
                if (az) {
                    ap.bind("mousedown.jsp", function (aN) {
                        if (aN.originalTarget === c || aN.originalTarget == aN.currentTarget) {
                            var aL = b(this),
                                aO = aL.offset(),
                                aM = aN.pageY - aO.top - I,
                                aJ, aI = true,
                                s = function () {
                                    var aR = aL.offset(),
                                        aS = aN.pageY - aR.top - A / 2,
                                        aP = v * ay.scrollPagePercent,
                                        aQ = i * aP / (Z - v);
                                    if (aM < 0) {
                                        if (I - aQ > aS) {
                                            Q.scrollByY(-aP)
                                        } else {
                                            V(aS)
                                        }
                                    } else {
                                        if (aM > 0) {
                                            if (I + aQ < aS) {
                                                Q.scrollByY(aP)
                                            } else {
                                                V(aS)
                                            }
                                        } else {
                                            aK();
                                            return
                                        }
                                    }
                                    aJ = setTimeout(s, aI ? ay.initialDelay : ay.trackClickRepeatFreq);
                                    aI = false
                                }, aK = function () {
                                    aJ && clearTimeout(aJ);
                                    aJ = null;
                                    b(document).unbind("mouseup.jsp", aK)
                                };
                            s();
                            b(document).bind("mouseup.jsp", aK);
                            return false
                        }
                    })
                }
                if (aE) {
                    G.bind("mousedown.jsp", function (aN) {
                        if (aN.originalTarget === c || aN.originalTarget == aN.currentTarget) {
                            var aL = b(this),
                                aO = aL.offset(),
                                aM = aN.pageX - aO.left - aa,
                                aJ, aI = true,
                                s = function () {
                                    var aR = aL.offset(),
                                        aS = aN.pageX - aR.left - at / 2,
                                        aP = aj * ay.scrollPagePercent,
                                        aQ = j * aP / (T - aj);
                                    if (aM < 0) {
                                        if (aa - aQ > aS) {
                                            Q.scrollByX(-aP)
                                        } else {
                                            W(aS)
                                        }
                                    } else {
                                        if (aM > 0) {
                                            if (aa + aQ < aS) {
                                                Q.scrollByX(aP)
                                            } else {
                                                W(aS)
                                            }
                                        } else {
                                            aK();
                                            return
                                        }
                                    }
                                    aJ = setTimeout(s, aI ? ay.initialDelay : ay.trackClickRepeatFreq);
                                    aI = false
                                }, aK = function () {
                                    aJ && clearTimeout(aJ);
                                    aJ = null;
                                    b(document).unbind("mouseup.jsp", aK)
                                };
                            s();
                            b(document).bind("mouseup.jsp", aK);
                            return false
                        }
                    })
                }
            }
            function w() {
                if (G) {
                    G.unbind("mousedown.jsp")
                }
                if (ap) {
                    ap.unbind("mousedown.jsp")
                }
            }
            function aw() {
                b("html").unbind("dragstart.jsp selectstart.jsp mousemove.jsp mouseup.jsp mouseleave.jsp");
                if (au) {
                    au.removeClass("jspActive")
                }
                if (h) {
                    h.removeClass("jspActive")
                }
            }
            function V(s, aI) {
                if (!az) {
                    return
                }
                if (s < 0) {
                    s = 0
                } else {
                    if (s > i) {
                        s = i
                    }
                } if (aI === c) {
                    aI = ay.animateScroll
                }
                if (aI) {
                    Q.animate(au, "top", s, ad)
                } else {
                    au.css("top", s);
                    ad(s)
                }
            }
            function ad(aI) {
                if (aI === c) {
                    aI = au.position().top
                }
                al.scrollTop(0);
                I = aI;
                var aL = I === 0,
                    aJ = I == i,
                    aK = aI / i,
                    s = -aK * (Z - v);
                if (ai != aL || aG != aJ) {
                    ai = aL;
                    aG = aJ;
                    D.trigger("jsp-arrow-change", [ai, aG, P, k])
                }
                u(aL, aJ);
                Y.css("top", s);
                D.trigger("jsp-scroll-y", [-s, aL, aJ]).trigger("scroll")
            }
            function W(aI, s) {
                if (!aE) {
                    return
                }
                if (aI < 0) {
                    aI = 0
                } else {
                    if (aI > j) {
                        aI = j
                    }
                } if (s === c) {
                    s = ay.animateScroll
                }
                if (s) {
                    Q.animate(h, "left", aI, ae)
                } else {
                    h.css("left", aI);
                    ae(aI)
                }
            }
            function ae(aI) {
                if (aI === c) {
                    aI = h.position().left
                }
                al.scrollTop(0);
                aa = aI;
                var aL = aa === 0,
                    aK = aa == j,
                    aJ = aI / j,
                    s = -aJ * (T - aj);
                if (P != aL || k != aK) {
                    P = aL;
                    k = aK;
                    D.trigger("jsp-arrow-change", [ai, aG, P, k])
                }
                r(aL, aK);
                Y.css("left", s);
                D.trigger("jsp-scroll-x", [-s, aL, aK]).trigger("scroll")
            }
            function u(aI, s) {
                if (ay.showArrows) {
                    aq[aI ? "addClass" : "removeClass"]("jspDisabled");
                    af[s ? "addClass" : "removeClass"]("jspDisabled")
                }
            }
            function r(aI, s) {
                if (ay.showArrows) {
                    ax[aI ? "addClass" : "removeClass"]("jspDisabled");
                    x[s ? "addClass" : "removeClass"]("jspDisabled")
                }
            }
            function M(s, aI) {
                var aJ = s / (Z - v);
                V(aJ * i, aI)
            }
            function N(aI, s) {
                var aJ = aI / (T - aj);
                W(aJ * j, s)
            }
            function ab(aV, aQ, aJ) {
                var aN, aK, aL, s = 0,
                    aU = 0,
                    aI, aP, aO, aS, aR, aT;
                try {
                    aN = b(aV)
                } catch (aM) {
                    return
                }
                aK = aN.outerHeight();
                aL = aN.outerWidth();
                al.scrollTop(0);
                al.scrollLeft(0);
                while (!aN.is(".jspPane")) {
                    s += aN.position().top;
                    aU += aN.position().left;
                    aN = aN.offsetParent();
                    if (/^body|html$/i.test(aN[0].nodeName)) {
                        return
                    }
                }
                aI = aA();
                aO = aI + v;
                if (s < aI || aQ) {
                    aR = s - ay.verticalGutter
                } else {
                    if (s + aK > aO) {
                        aR = s - v + aK + ay.verticalGutter
                    }
                } if (aR) {
                    M(aR, aJ)
                }
                aP = aC();
                aS = aP + aj;
                if (aU < aP || aQ) {
                    aT = aU - ay.horizontalGutter
                } else {
                    if (aU + aL > aS) {
                        aT = aU - aj + aL + ay.horizontalGutter
                    }
                } if (aT) {
                    N(aT, aJ)
                }
            }
            function aC() {
                return -Y.position().left
            }
            function aA() {
                return -Y.position().top
            }
            function K() {
                var s = Z - v;
                return (s > 20) && (s - aA() < 10)
            }
            function B() {
                var s = T - aj;
                return (s > 20) && (s - aC() < 10)
            }
            function ag() {
                al.unbind(ac).bind(ac, function (aL, aM, aK, aI) {
                    var aJ = aa,
                        s = I;
                    Q.scrollBy(aK * ay.mouseWheelSpeed, -aI * ay.mouseWheelSpeed, false);
                    return aJ == aa && s == I
                })
            }
            function n() {
                al.unbind(ac)
            }
            function aB() {
                return false
            }
            function J() {
                Y.find(":input,a").unbind("focus.jsp").bind("focus.jsp", function (s) {
                    ab(s.target, false)
                })
            }
            function E() {
                Y.find(":input,a").unbind("focus.jsp")
            }
            function S() {
                var s, aI, aK = [];
                aE && aK.push(am[0]);
                az && aK.push(U[0]);
                Y.focus(function () {
                    D.focus()
                });
                D.attr("tabindex", 0).unbind("keydown.jsp keypress.jsp").bind("keydown.jsp", function (aN) {
                    if (aN.target !== this && !(aK.length && b(aN.target).closest(aK).length)) {
                        return
                    }
                    var aM = aa,
                        aL = I;
                    switch (aN.keyCode) {
                        case 40:
                        case 38:
                        case 34:
                        case 32:
                        case 33:
                        case 39:
                        case 37:
                            s = aN.keyCode;
                            aJ();
                            break;
                        case 35:
                            M(Z - v);
                            s = null;
                            break;
                        case 36:
                            M(0);
                            s = null;
                            break
                    }
                    aI = aN.keyCode == s && aM != aa || aL != I;
                    return !aI
                }).bind("keypress.jsp", function (aL) {
                    if (aL.keyCode == s) {
                        aJ()
                    }
                    return !aI
                });
                if (ay.hideFocus) {
                    D.css("outline", "none");
                    if ("hideFocus" in al[0]) {
                        D.attr("hideFocus", true)
                    }
                } else {
                    D.css("outline", "");
                    if ("hideFocus" in al[0]) {
                        D.attr("hideFocus", false)
                    }
                }
                function aJ() {
                    var aM = aa,
                        aL = I;
                    switch (s) {
                        case 40:
                            Q.scrollByY(ay.keyboardSpeed, false);
                            break;
                        case 38:
                            Q.scrollByY(-ay.keyboardSpeed, false);
                            break;
                        case 34:
                        case 32:
                            Q.scrollByY(v * ay.scrollPagePercent, false);
                            break;
                        case 33:
                            Q.scrollByY(-v * ay.scrollPagePercent, false);
                            break;
                        case 39:
                            Q.scrollByX(ay.keyboardSpeed, false);
                            break;
                        case 37:
                            Q.scrollByX(-ay.keyboardSpeed, false);
                            break
                    }
                    aI = aM != aa || aL != I;
                    return aI
                }
            }
            function R() {
                D.attr("tabindex", "-1").removeAttr("tabindex").unbind("keydown.jsp keypress.jsp")
            }
            function C() {
                if (location.hash && location.hash.length > 1) {
                    var aK, aI, aJ = escape(location.hash.substr(1));
                    try {
                        aK = b("#" + aJ + ', a[name="' + aJ + '"]')
                    } catch (s) {
                        return
                    }
                    if (aK.length && Y.find(aJ)) {
                        if (al.scrollTop() === 0) {
                            aI = setInterval(function () {
                                if (al.scrollTop() > 0) {
                                    ab(aK, true);
                                    b(document).scrollTop(al.position().top);
                                    clearInterval(aI)
                                }
                            }, 50)
                        } else {
                            ab(aK, true);
                            b(document).scrollTop(al.position().top)
                        }
                    }
                }
            }
            function m() {
                if (b(document.body).data("jspHijack")) {
                    return
                }
                b(document.body).data("jspHijack", true);
                b(document.body).delegate("a[href*=#]", "click", function (s) {
                    var aI = this.href.substr(0, this.href.indexOf("#")),
                        aK = location.href,
                        aO, aP, aJ, aM, aL, aN;
                    if (location.href.indexOf("#") !== -1) {
                        aK = location.href.substr(0, location.href.indexOf("#"))
                    }
                    if (aI !== aK) {
                        return
                    }
                    aO = escape(this.href.substr(this.href.indexOf("#") + 1));
                    aP;
                    try {
                        aP = b("#" + aO + ', a[name="' + aO + '"]')
                    } catch (aQ) {
                        return
                    }
                    if (!aP.length) {
                        return
                    }
                    aJ = aP.closest(".jspScrollable");
                    aM = aJ.data("jsp");
                    aM.scrollToElement(aP, true);
                    if (aJ[0].scrollIntoView) {
                        aL = b(a).scrollTop();
                        aN = aP.offset().top;
                        if (aN < aL || aN > aL + b(a).height()) {
                            aJ[0].scrollIntoView()
                        }
                    }
                    s.preventDefault()
                })
            }
            function an() {
                var aJ, aI, aL, aK, aM, s = false;
                al.unbind("touchstart.jsp touchmove.jsp touchend.jsp click.jsp-touchclick").bind("touchstart.jsp", function (aN) {
                    var aO = aN.originalEvent.touches[0];
                    aJ = aC();
                    aI = aA();
                    aL = aO.pageX;
                    aK = aO.pageY;
                    aM = false;
                    s = true
                }).bind("touchmove.jsp", function (aQ) {
                    if (!s) {
                        return
                    }
                    var aP = aQ.originalEvent.touches[0],
                        aO = aa,
                        aN = I;
                    Q.scrollTo(aJ + aL - aP.pageX, aI + aK - aP.pageY);
                    aM = aM || Math.abs(aL - aP.pageX) > 5 || Math.abs(aK - aP.pageY) > 5;
                    return aO == aa && aN == I
                }).bind("touchend.jsp", function (aN) {
                    s = false
                }).bind("click.jsp-touchclick", function (aN) {
                    if (aM) {
                        aM = false;
                        return false
                    }
                })
            }
            function g() {
                var s = aA(),
                    aI = aC();
                D.removeClass("jspScrollable").unbind(".jsp");
                D.replaceWith(ao.append(Y.children()));
                ao.scrollTop(s);
                ao.scrollLeft(aI);
                if (av) {
                    clearInterval(av)
                }
            }
            b.extend(Q, {
                reinitialise: function (aI) {
                    aI = b.extend({}, ay, aI);
                    ar(aI)
                },
                scrollToElement: function (aJ, aI, s) {
                    ab(aJ, aI, s)
                },
                scrollTo: function (aJ, s, aI) {
                    N(aJ, aI);
                    M(s, aI)
                },
                scrollToX: function (aI, s) {
                    N(aI, s)
                },
                scrollToY: function (s, aI) {
                    M(s, aI)
                },
                scrollToPercentX: function (aI, s) {
                    N(aI * (T - aj), s)
                },
                scrollToPercentY: function (aI, s) {
                    M(aI * (Z - v), s)
                },
                scrollBy: function (aI, s, aJ) {
                    Q.scrollByX(aI, aJ);
                    Q.scrollByY(s, aJ)
                },
                scrollByX: function (s, aJ) {
                    var aI = aC() + Math[s < 0 ? "floor" : "ceil"](s),
                        aK = aI / (T - aj);
                    W(aK * j, aJ)
                },
                scrollByY: function (s, aJ) {
                    var aI = aA() + Math[s < 0 ? "floor" : "ceil"](s),
                        aK = aI / (Z - v);
                    V(aK * i, aJ)
                },
                positionDragX: function (s, aI) {
                    W(s, aI)
                },
                positionDragY: function (aI, s) {
                    V(aI, s)
                },
                animate: function (aI, aL, s, aK) {
                    var aJ = {};
                    aJ[aL] = s;
                    aI.animate(aJ, {
                        duration: ay.animateDuration,
                        easing: ay.animateEase,
                        queue: false,
                        step: aK
                    })
                },
                getContentPositionX: function () {
                    return aC()
                },
                getContentPositionY: function () {
                    return aA()
                },
                getContentWidth: function () {
                    return T
                },
                getContentHeight: function () {
                    return Z
                },
                getPercentScrolledX: function () {
                    return aC() / (T - aj)
                },
                getPercentScrolledY: function () {
                    return aA() / (Z - v)
                },
                getIsScrollableH: function () {
                    return aE
                },
                getIsScrollableV: function () {
                    return az
                },
                getContentPane: function () {
                    return Y
                },
                scrollToBottom: function (s) {
                    V(i, s)
                },
                hijackInternalLinks: b.noop,
                destroy: function () {
                    g()
                }
            });
            ar(O)
        }
        e = b.extend({}, b.fn.jScrollPane.defaults, e);
        b.each(["mouseWheelSpeed", "arrowButtonSpeed", "trackClickSpeed", "keyboardSpeed"], function () {
            e[this] = e[this] || e.speed
        });
        return this.each(function () {
            var f = b(this),
                g = f.data("jsp");
            if (g) {
                g.reinitialise(e)
            } else {
                b("script", f).filter('[type="text/javascript"],:not([type])').remove();
                g = new d(f, e);
                f.data("jsp", g)
            }
        })
    };
    b.fn.jScrollPane.defaults = {
        showArrows: false,
        maintainPosition: true,
        stickToBottom: false,
        stickToRight: false,
        clickOnTrack: true,
        autoReinitialise: false,
        autoReinitialiseDelay: 500,
        verticalDragMinHeight: 0,
        verticalDragMaxHeight: 99999,
        horizontalDragMinWidth: 0,
        horizontalDragMaxWidth: 99999,
        contentWidth: c,
        animateScroll: false,
        animateDuration: 300,
        animateEase: "linear",
        hijackInternalLinks: false,
        verticalGutter: 4,
        horizontalGutter: 4,
        mouseWheelSpeed: 0,
        arrowButtonSpeed: 0,
        arrowRepeatFreq: 50,
        arrowScrollOnHover: false,
        trackClickSpeed: 0,
        trackClickRepeatFreq: 70,
        verticalArrowPositions: "split",
        horizontalArrowPositions: "split",
        enableKeyboardNavigation: true,
        hideFocus: false,
        keyboardSpeed: 0,
        initialDelay: 300,
        speed: 30,
        scrollPagePercent: 0.8
    }
})(jQuery, this);;
(function (b) {
    b.support.touch = "ontouchend" in document;
    if (!b.support.touch) {
        return;
    }
    var c = b.ui.mouse.prototype,
        e = c._mouseInit,
        a;

    function d(g, h) {
        if (g.originalEvent.touches.length > 1) {
            return;
        }
        g.preventDefault();
        var i = g.originalEvent.changedTouches[0],
            f = document.createEvent("MouseEvents");
        f.initMouseEvent(h, true, true, window, 1, i.screenX, i.screenY, i.clientX, i.clientY, false, false, false, false, 0, null);
        g.target.dispatchEvent(f);
    }
    c._touchStart = function (g) {
        var f = this;
        if (a || !f._mouseCapture(g.originalEvent.changedTouches[0])) {
            return;
        }
        a = true;
        f._touchMoved = false;
        d(g, "mouseover");
        d(g, "mousemove");
        d(g, "mousedown");
    };
    c._touchMove = function (f) {
        if (!a) {
            return;
        }
        this._touchMoved = true;
        d(f, "mousemove");
    };
    c._touchEnd = function (f) {
        if (!a) {
            return;
        }
        d(f, "mouseup");
        d(f, "mouseout");
        if (!this._touchMoved) {
            d(f, "click");
        }
        a = false;
    };
    c._mouseInit = function () {
        var f = this;
        f.element.bind("touchstart", b.proxy(f, "_touchStart")).bind("touchmove", b.proxy(f, "_touchMove")).bind("touchend", b.proxy(f, "_touchEnd"));
        e.call(f);
    };
})(jQuery);;
(function (c) {
    c.address = function () {
        var r = function (a) {
            a = c.extend(c.Event(a), function () {
                for (var b = {}, f = c.address.parameterNames(), m = 0, p = f.length; m < p; m++) b[f[m]] = c.address.parameter(f[m]);
                return {
                    value: c.address.value(),
                    path: c.address.path(),
                    pathNames: c.address.pathNames(),
                    parameterNames: f,
                    parameters: b,
                    queryString: c.address.queryString()
                }
            }.call(c.address));
            c(c.address).trigger(a);
            return a
        }, s = function (a) {
                return Array.prototype.slice.call(a)
            }, h = function () {
                c().bind.apply(c(c.address), Array.prototype.slice.call(arguments));
                return c.address
            }, ea = function () {
                c().unbind.apply(c(c.address), Array.prototype.slice.call(arguments));
                return c.address
            }, E = function () {
                return z.pushState && d.state !== g
            }, U = function () {
                return ("/" + i.pathname.replace(new RegExp(d.state), "") + i.search + (L() ? "#" + L() : "")).replace(T, "/")
            }, L = function () {
                var a = i.href.indexOf("#");
                return a != -1 ? t(i.href.substr(a + 1), k) : ""
            }, u = function () {
                return E() ? U() : L()
            }, V = function () {
                return "javascript"
            }, O = function (a) {
                a = a.toString();
                return (d.strict && a.substr(0, 1) != "/" ? "/" : "") + a
            }, t = function (a, b) {
                if (d.crawlable && b) return (a !== "" ? "!" : "") + a;
                return a.replace(/^\!/, "")
            }, v = function (a, b) {
                return parseInt(a.css(b), 10)
            }, H = function () {
                if (!x) {
                    var a = u();
                    if (decodeURI(e) != decodeURI(a)) if (w && A < 7) i.reload();
                        else {
                            w && !F && d.history && q(M, 50);
                            _old = e;
                            e = a;
                            G(k)
                        }
                }
            }, G = function (a) {
                var b = r(W);
                a = r(a ? X : Y);
                q(fa, 10);
                if (b.isDefaultPrevented() || a.isDefaultPrevented()) ga()
            }, ga = function () {
                e = _old;
                if (E()) z.popState({}, "", d.state.replace(/\/$/, "") + (e === "" ? "/" : e));
                else {
                    x = n;
                    if (B) if (d.history) i.hash = "#" + t(e, n);
                        else i.replace("#" +
                                t(e, n));
                        else if (e != u()) if (d.history) i.hash = "#" + t(e, n);
                        else i.replace("#" + t(e, n));
                    w && !F && d.history && q(M, 50);
                    if (B) q(function () {
                            x = k
                        }, 1);
                    else x = k
                }
            }, fa = function () {
                if (d.tracker !== "null" && d.tracker !== I) {
                    var a = c.isFunction(d.tracker) ? d.tracker : j[d.tracker],
                        b = (i.pathname + i.search + (c.address && !E() ? c.address.value() : "")).replace(/\/\//, "/").replace(/^\/$/, "");
                    if (c.isFunction(a)) a(b);
                    else if (c.isFunction(j.urchinTracker)) j.urchinTracker(b);
                    else if (j.pageTracker !== g && c.isFunction(j.pageTracker._trackPageview)) j.pageTracker._trackPageview(b);
                    else j._gaq !== g && c.isFunction(j._gaq.push) && j._gaq.push(["_trackPageview", decodeURI(b)])
                }
            }, M = function () {
                var a = V() + ":" + k + ";document.open();document.writeln('<html><head><title>" + o.title.replace(/\'/g, "\\'") + "</title><script>var " + C + ' = "' + encodeURIComponent(u()).replace(/\'/g, "\\'") + (o.domain != i.hostname ? '";document.domain="' + o.domain : "") + "\";<\/script></head></html>');document.close();";
                if (A < 7) l.src = a;
                else l.contentWindow.location.replace(a)
            }, $ = function () {
                if (J && Z != -1) {
                    var a, b, f = J.substr(Z + 1).split("&");
                    for (a = 0; a < f.length; a++) {
                        b = f[a].split("=");
                        if (/^(autoUpdate|crawlable|history|strict|wrap)$/.test(b[0])) d[b[0]] = isNaN(b[1]) ? /^(true|yes)$/i.test(b[1]) : parseInt(b[1], 10) !== 0;
                        if (/^(state|tracker)$/.test(b[0])) d[b[0]] = b[1]
                    }
                    J = I
                }
                _old = e;
                e = u()
            }, ba = function () {
                if (!aa) {
                    aa = n;
                    $();
                    var a = function () {
                        ha.call(this);
                        ia.call(this)
                    }, b = c("body").ajaxComplete(a);
                    a();
                    if (d.wrap) {
                        c("body > *").wrapAll('<div style="padding:' + (v(b, "marginTop") + v(b, "paddingTop")) + "px " + (v(b, "marginRight") + v(b, "paddingRight")) + "px " + (v(b, "marginBottom") +
                            v(b, "paddingBottom")) + "px " + (v(b, "marginLeft") + v(b, "paddingLeft")) + 'px;" />').parent().wrap('<div id="' + C + '" style="height:100%;overflow:auto;position:relative;' + (B && !window.statusbar.visible ? "resize:both;" : "") + '" />');
                        c("html, body").css({
                            height: "100%",
                            margin: 0,
                            padding: 0,
                            overflow: "hidden"
                        });
                        B && c('<style type="text/css" />').appendTo("head").text("#" + C + "::-webkit-resizer { background-color: #fff; }")
                    }
                    if (w && !F) {
                        a = o.getElementsByTagName("frameset")[0];
                        l = o.createElement((a ? "" : "i") + "frame");
                        l.src = V() + ":" + k;
                        if (a) {
                            a.insertAdjacentElement("beforeEnd", l);
                            a[a.cols ? "cols" : "rows"] += ",0";
                            l.noResize = n;
                            l.frameBorder = l.frameSpacing = 0
                        } else {
                            l.style.display = "none";
                            l.style.width = l.style.height = 0;
                            l.tabIndex = -1;
                            o.body.insertAdjacentElement("afterBegin", l)
                        }
                        q(function () {
                            c(l).bind("load", function () {
                                var f = l.contentWindow;
                                _old = e;
                                e = f[C] !== g ? f[C] : "";
                                if (e != u()) {
                                    G(k);
                                    i.hash = t(e, n)
                                }
                            });
                            l.contentWindow[C] === g && M()
                        }, 50)
                    }
                    q(function () {
                        r("init");
                        G(k)
                    }, 1);
                    if (!E()) if (w && A > 7 || !w && F) if (j.addEventListener) j.addEventListener(K, H, k);
                            else j.attachEvent && j.attachEvent("on" + K, H);
                            else ja(H, 50);
                            "state" in window.history && c(window).trigger("popstate")
                }
            }, ha = function () {
                var a, b = c("a"),
                    f = b.size(),
                    m = -1,
                    p = function () {
                        if (++m != f) {
                            a = c(b.get(m));
                            a.is('[rel*="address:"]') && a.address('[rel*="address:"]');
                            q(p, 1)
                        }
                    };
                q(p, 1)
            }, ia = function () {
                if (d.crawlable) {
                    var a = i.pathname.replace(/\/$/, "");
                    c("body").html().indexOf("_escaped_fragment_") != -1 && c('a[href]:not([href^=http]), a[href*="' + document.domain + '"]').each(function () {
                        var b = c(this).attr("href").replace(/^http:/, "").replace(new RegExp(a + "/?$"), "");
                        if (b === "" || b.indexOf("_escaped_fragment_") != -1) c(this).attr("href", "#" + encodeURI(decodeURIComponent(b.replace(/\/(.*)\?_escaped_fragment_=(.*)$/, "!$2"))))
                    })
                }
            }, g, I = null,
            C = "jQueryAddress",
            K = "hashchange",
            W = "change",
            X = "internalChange",
            Y = "externalChange",
            n = true,
            k = false,
            d = {
                autoUpdate: n,
                crawlable: k,
                history: n,
                strict: n,
                wrap: k
            }, D = c.browser,
            A = parseFloat(D.version),
            w = !c.support.opacity,
            B = D.webkit || D.safari,
            j = function () {
                try {
                    return top.document !== g && top.document.title !== g ? top : window
                } catch (a) {
                    return window
                }
            }(),
            o = j.document,
            z = j.history,
            i = j.location,
            ja = setInterval,
            q = setTimeout,
            T = /\/{2,9}/g;
        D = navigator.userAgent;
        var F = "on" + K in j,
            l, J = c("script:last").attr("src"),
            Z = J ? J.indexOf("?") : -1,
            P = o.title,
            x = k,
            aa = k,
            ca = n,
            N = k,
            e = u();
        _old = e;
        if (w) {
            A = parseFloat(D.substr(D.indexOf("MSIE") + 4));
            if (o.documentMode && o.documentMode != A) A = o.documentMode != 8 ? 7 : 8;
            var da = o.onpropertychange;
            o.onpropertychange = function () {
                da && da.call(o);
                if (o.title != P && o.title.indexOf("#" + u()) != -1) o.title = P
            }
        }
        if (z.navigationMode) z.navigationMode = "compatible";
        if (document.readyState == "complete") var ka = setInterval(function () {
                if (c.address) {
                    ba();
                    clearInterval(ka)
                }
            }, 50);
        else {
            $();
            c(ba)
        }
        c(window).bind("popstate", function () {
            if (decodeURI(e) != decodeURI(u())) {
                _old = e;
                e = u();
                G(k)
            }
        }).bind("unload", function () {
            if (j.removeEventListener) j.removeEventListener(K, H, k);
            else j.detachEvent && j.detachEvent("on" + K, H)
        });
        return {
            bind: function () {
                return h.apply(this, s(arguments))
            },
            unbind: function () {
                return ea.apply(this, s(arguments))
            },
            init: function () {
                return h.apply(this, ["init"].concat(s(arguments)))
            },
            change: function () {
                return h.apply(this, [W].concat(s(arguments)))
            },
            internalChange: function () {
                return h.apply(this, [X].concat(s(arguments)))
            },
            externalChange: function () {
                return h.apply(this, [Y].concat(s(arguments)))
            },
            baseURL: function () {
                var a = i.href;
                if (a.indexOf("#") != -1) a = a.substr(0, a.indexOf("#"));
                if (/\/$/.test(a)) a = a.substr(0, a.length - 1);
                return a
            },
            autoUpdate: function (a) {
                if (a !== g) {
                    d.autoUpdate = a;
                    return this
                }
                return d.autoUpdate
            },
            crawlable: function (a) {
                if (a !== g) {
                    d.crawlable = a;
                    return this
                }
                return d.crawlable
            },
            history: function (a) {
                if (a !== g) {
                    d.history = a;
                    return this
                }
                return d.history
            },
            state: function (a) {
                if (a !== g) {
                    d.state = a;
                    var b = U();
                    if (d.state !== g) if (z.pushState) b.substr(0, 3) == "/#/" && i.replace(d.state.replace(/^\/$/, "") + b.substr(2));
                        else b != "/" && b.replace(/^\/#/, "") != L() && q(function () {
                                i.replace(d.state.replace(/^\/$/, "") + "/#" + b)
                            }, 1);
                    return this
                }
                return d.state
            },
            strict: function (a) {
                if (a !== g) {
                    d.strict = a;
                    return this
                }
                return d.strict
            },
            tracker: function (a) {
                if (a !== g) {
                    d.tracker = a;
                    return this
                }
                return d.tracker
            },
            wrap: function (a) {
                if (a !== g) {
                    d.wrap = a;
                    return this
                }
                return d.wrap
            },
            update: function () {
                N = n;
                this.value(e);
                N = k;
                return this
            },
            title: function (a) {
                if (a !== g) {
                    q(function () {
                        P = o.title = a;
                        if (ca && l && l.contentWindow && l.contentWindow.document) {
                            l.contentWindow.document.title = a;
                            ca = k
                        }
                    }, 50);
                    return this
                }
                return o.title
            },
            value: function (a) {
                if (a !== g) {
                    a = O(a);
                    if (a == "/") a = "";
                    if (e == a && !N) return;
                    _old = e;
                    e = a;
                    if (d.autoUpdate || N) {
                        G(n);
                        if (E()) z[d.history ? "pushState" : "replaceState"]({}, "", d.state.replace(/\/$/, "") + (e === "" ? "/" : e));
                        else {
                            x = n;
                            if (B) if (d.history) i.hash = "#" + t(e, n);
                                else i.replace("#" + t(e, n));
                                else if (e != u()) if (d.history) i.hash = "#" + t(e, n);
                                else i.replace("#" + t(e, n));
                            w && !F && d.history && q(M, 50);
                            if (B) q(function () {
                                    x = k
                                }, 1);
                            else x = k
                        }
                    }
                    return this
                }
                return O(e)
            },
            path: function (a) {
                if (a !== g) {
                    var b = this.queryString(),
                        f = this.hash();
                    this.value(a + (b ? "?" + b : "") + (f ? "#" + f : ""));
                    return this
                }
                return O(e).split("#")[0].split("?")[0]
            },
            pathNames: function () {
                var a = this.path(),
                    b = a.replace(T, "/").split("/");
                if (a.substr(0, 1) == "/" || a.length === 0) b.splice(0, 1);
                a.substr(a.length - 1, 1) == "/" && b.splice(b.length - 1, 1);
                return b
            },
            queryString: function (a) {
                if (a !== g) {
                    var b = this.hash();
                    this.value(this.path() + (a ? "?" + a : "") + (b ? "#" + b : ""));
                    return this
                }
                a = e.split("?");
                return a.slice(1, a.length).join("?").split("#")[0]
            },
            parameter: function (a, b, f) {
                var m, p;
                if (b !== g) {
                    var Q = this.parameterNames();
                    p = [];
                    b = b === g || b === I ? "" : b.toString();
                    for (m = 0; m < Q.length; m++) {
                        var R = Q[m],
                            y = this.parameter(R);
                        if (typeof y == "string") y = [y];
                        if (R == a) y = b === I || b === "" ? [] : f ? y.concat([b]) : [b];
                        for (var S = 0; S < y.length; S++) p.push(R + "=" + y[S])
                    }
                    c.inArray(a, Q) == -1 && b !== I && b !== "" && p.push(a + "=" + b);
                    this.queryString(p.join("&"));
                    return this
                }
                if (b = this.queryString()) {
                    f = [];
                    p = b.split("&");
                    for (m = 0; m < p.length; m++) {
                        b = p[m].split("=");
                        b[0] == a && f.push(b.slice(1).join("="))
                    }
                    if (f.length !== 0) return f.length != 1 ? f : f[0]
                }
            },
            parameterNames: function () {
                var a = this.queryString(),
                    b = [];
                if (a && a.indexOf("=") != -1) {
                    a = a.split("&");
                    for (var f = 0; f < a.length; f++) {
                        var m = a[f].split("=")[0];
                        c.inArray(m, b) == -1 && b.push(m)
                    }
                }
                return b
            },
            hash: function (a) {
                if (a !== g) {
                    this.value(e.split("#")[0] + (a ? "#" +
                        a : ""));
                    return this
                }
                a = e.split("#");
                return a.slice(1, a.length).join("#")
            }
        }
    }();
    c.fn.address = function (r) {
        var s;
        if (typeof r == "string") {
            s = r;
            r = undefined
        }
        c(this).attr("address") || c(s ? s : this).live("click", function (h) {
            if (h.shiftKey || h.ctrlKey || h.metaKey || h.which == 2) return true;
            if (c(this).is("a")) {
                h.preventDefault();
                h = r ? r.call(this) : /address:/.test(c(this).attr("rel")) ? c(this).attr("rel").split("address:")[1].split(" ")[0] : c.address.state() !== undefined && !/^\/?$/.test(c.address.state()) ? c(this).attr("href").replace(new RegExp("^(.*" +
                    c.address.state() + "|\\.)"), "") : c(this).attr("href").replace(/^(#\!?|\.)/, "");
                c.address.value(h)
            }
        }).live("submit", function (h) {
            if (c(this).is("form")) {
                h.preventDefault();
                h = c(this).attr("action");
                h = r ? r.call(this) : (h.indexOf("?") != -1 ? h.replace(/&$/, "") : h + "?") + c(this).serialize();
                c.address.value(h)
            }
        }).attr("address", true);
        return this
    }
})(jQuery);;
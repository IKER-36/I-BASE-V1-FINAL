(function($) {
    "use strict";
    $(window).load(function() {
        $("#preloader").fadeOut(1400);
        $("#preloader-status").delay(300).fadeOut("slow");
        setTimeout(function() {
            $(".introduction").delay(2200).css({
                display: "none"
            }).fadeIn(1000);
            $("#particles-holder").delay(2200).css({
                display: "none"
            }).fadeIn(1000);
            $("#customizer, .corner").delay(2400).css({
                display: "none"
            }).fadeIn(1000)
        }, 0);
        setTimeout(function() {
            $(".transparent-borders").removeClass("OFF")
        }, 1600);
        setTimeout(function() {
            $(".logo, #menu").removeClass("top-position")
        }, 2200);
        setTimeout(function() {
            $(".launcher, .social-icons-wrapper").removeClass("bottom-position")
        }, 2200);
        setTimeout(function() {
            $(".line-left").removeClass("left-position")
        }, 2200);
        setTimeout(function() {
            $(".line-right").removeClass("right-position")
        }, 2200);
        $(".hero-bg").addClass("hero-bg-show")
    });
    $("#kenburnsy-bg").kenburnsy({
        fullscreen: !0
    });
    $("#fire-home").on("click", function(e) {
        e.preventDefault();
        $(".current").removeClass("current").fadeOut(1200, function() {
            $("#home").fadeIn(2200).addClass("current")
        })
    });
    $("#fire-services").on("click", function(e) {
        e.preventDefault();
        $(".current").removeClass("current").fadeOut(1200, function() {
            $("#services").fadeIn(2200).addClass("current")
        })
    });
    $("#fire-contact").on("click", function(e) {
        e.preventDefault();
        $(".current").removeClass("current").fadeOut(1200, function() {
            $("#contact").fadeIn(2200).addClass("current")
        })
    });
    $("a.menu-state").on("click", function() {
        $("a.menu-state").removeClass("active");
        $(this).addClass("active")
    });
    $(function() {
        $(".player").mb_YTPlayer()
    });
    $("form#form").submit(function() {
        $("form#form .error").remove();
        var s = !1;
        if ($(".requiredField").each(function() {
                if ("" === jQuery.trim($(this).val())) $(this).prev("label").text(), $(this).parent().append('<span class="error">This field is required</span>'), $(this).addClass("inputError"), s = !0;
                else if ($(this).hasClass("email")) {
                    var r = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
                    r.test(jQuery.trim($(this).val())) || ($(this).prev("label").text(), $(this).parent().append('<span class="error">Invalid email address</span>'), $(this).addClass("inputError"), s = !0)
                }
            }), !s) {
            $("form#form input.submit").fadeOut("normal", function() {
                $(this).parent().append("")
            });
            var r = $(this).serialize();
            $.post($(this).attr("action"), r, function() {
                $("form#form").slideUp("fast", function() {
                    $(this).before('<div class="success">Your email was sent successfully.</div>')
                })
            })
        }
        return !1
    });
    $(".popup-photo").magnificPopup({
        type: "image",
        gallery: {
            enabled: !0,
            tPrev: "",
            tNext: "",
            tCounter: "%curr% / %total%"
        },
        removalDelay: 300,
        mainClass: "mfp-fade"
    });
    $(".fin-slides").owlCarousel({
        navigation: !1,
        pagination: !1,
        transitionStyle: "fade",
        slideSpeed: 300,
        paginationSpeed: 400,
        singleItem: !0,
        autoPlay: 5000
    });
    $(".photos-gallery-slider").owlCarousel({
        slideSpeed: 300,
        paginationSpeed: 400,
        singleItem: !1,
        items: 2,
        itemsDesktop: [1199, 2],
        itemsDesktopSmall: [979, 2],
        autoHeight: !1,
        navigation: !0,
        navigationText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"]
    });
    $(".hero-slider-split").owlCarousel({
        autoPlay: !0,
        navigation: !1,
        pagination: !1,
        slideSpeed: 300,
        paginationSpeed: 800,
        singleItem: !1,
        items: 2,
        autoHeight: !0
    });
    $(".hero-slider-zoom").owlCarousel({
        autoPlay: !0,
        navigation: !1,
        pagination: !1,
        transitionStyle: "fadeUp",
        slideSpeed: 300,
        paginationSpeed: 400,
        singleItem: !0,
        items: 1,
        autoHeight: !0
    });
    var isMobile = {
        Android: function() {
            return navigator.userAgent.match(/Android/i)
        },
        BlackBerry: function() {
            return navigator.userAgent.match(/BlackBerry/i)
        },
        iOS: function() {
            return navigator.userAgent.match(/iPhone|iPad|iPod/i)
        },
        Opera: function() {
            return navigator.userAgent.match(/Opera Mini/i)
        },
        Windows: function() {
            return navigator.userAgent.match(/IEMobile/i)
        },
        any: function() {
            return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows())
        }
    }
})(jQuery);

function demo() {
    var engine = new RainyDay("canvas", "background", window.innerWidth, window.innerHeight);
    engine.gravity = engine.GRAVITY_NON_LINEAR;
    engine.trail = engine.TRAIL_DROPS;
    engine.rain([engine.preset(0, 2, 500)]);
    engine.rain([engine.preset(3, 3, 0.88), engine.preset(5, 5, 0.9), engine.preset(6, 2, 1), ], 100)
}
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-3033286-18']);
_gaq.push(['_trackPageview']);
(function() {
    var ga = document.createElement('script');
    ga.type = 'text/javascript';
    ga.async = !0;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(ga, s)
})();
const bd = document.body,
    cur = document.getElementById("cursor");
bd.addEventListener("mousemove", function(n) {
    (cur.style.left = n.clientX + "px"), (cur.style.top = n.clientY + "px")
})
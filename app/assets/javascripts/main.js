/* detect touch device
------------------------------------*/
$(function ($) {
	if ( is_touch_device() ) {
		$('html').addClass('touch');
	}
});



/* header
------------------------------------*/
$(function ($) {

	const $header = $('.header');

	if ( !$header.length ) return false;

	const $navBtn = $('.header-nav-btn');
	const $box = $('.header-box');
	const $pageWrapper = $('.page-wrapper');

	$navBtn.on('click', function () {
		$navBtn.toggleClass('active');
		$box.toggleClass('active');
		$header.toggleClass('active');
		$pageWrapper.toggleClass('active');
	});

});



/* filter
------------------------------------*/
$(function ($) {

	const $filter = $('.filter');

	if ( !$filter.length ) return false;

	var $form = $('#filter-search');

	const $key = $('#key');
	const $search_elements = $('#search_elements');
	const $non_search_elements = $('#non_search_elements');
	const $release_v1 = $('#release_v1');
	const $release_v2 = $('#release_v2');

	const release = document.getElementById('release');

	var paddingMin = $('#release_min');
	var paddingMax = $('#release_max');

	const paddingMinValue = $('#release_min').val().trim();
	const paddingMaxValue = $('#release_max').val().trim();

	var min = +release.getAttribute('data-min');
	var max = +release.getAttribute('data-max');

	const $elements = $('.filter-element');

	const $clear = $('#filter-clear');

	const $submit = $('#filter-submit');

	noUiSlider.create(release, {
		start: [paddingMinValue, paddingMaxValue],
		step: 1,
		behaviour: 'drag',
		connect: true,
		range: {
			'min': min,
			'max': max
		}
	});

	release.noUiSlider.on('update', function (values, handle) {
		if (handle) {
			paddingMax.val(Math.floor(values[handle]));
		} else {
			paddingMin.val( Math.floor(values[handle]));
		}
	});

	if ( $search_elements.val() ) {
		var items = $search_elements.val().split('-');

		$.each(items, function (index, value) {
			$('.filter-element[data-id="' + value + '"]')
				.removeClass('badge-secondary')
				.addClass('filter-element-checked badge-type1');
		});
	}

	if ( $non_search_elements.val() ) {
		var items = $non_search_elements.val().split('-');

		$.each(items, function (index, value) {
			$('.filter-element[data-id="' + value + '"]')
				.removeClass('badge-secondary')
				.addClass('filter-element-unchecked badge-alert');
		});
	}

	$elements.on('click', function () {
		var $element = $(this);

		if ( $element.hasClass('filter-element-checked') ) {
			$element.removeClass('filter-element-checked badge-type1');
			$element.addClass('filter-element-unchecked badge-alert');
		}
		else if ( $element.hasClass('filter-element-unchecked') ) {
			$element.removeClass('filter-element-unchecked badge-alert');
			$element.addClass('badge-secondary');
		}
		else {
			$element.removeClass('badge-secondary');
			$element.addClass('filter-element-checked badge-type1');
		}
	});

	$clear.on('click', function (event) {
		event.stopPropagation();

		$elements
			.removeClass('filter-element-checked filter-element-unchecked badge-type1 badge-alert')
			.addClass('badge-secondary');

		release.noUiSlider.set([min, max]);

		$search_elements.val('');
		$non_search_elements.val('');
		$release_v1.val('');
		$release_v2.val('');
	});

	$submit.on('click', function () {
		var $checked = $('.filter-element-checked');
		var $unchecked = $('.filter-element-unchecked');

		var key = $key.val().trim();
		var search_elements = '';
		var non_search_elements = '';
		var release_v1 = $('#release_min').val().trim();
		var release_v2 = $('#release_max').val().trim();

		$.each($checked, function (index, value) {
			if ( index ) {
				search_elements += '-';
			}

			search_elements += $(this).attr('data-id').trim();
		});

		$.each($unchecked, function (index, value) {
			if ( index ) {
				non_search_elements += '-';
			}

			non_search_elements += $(this).attr('data-id').trim();
		});

		$search_elements.val(search_elements);
		$non_search_elements.val(non_search_elements);
		$release_v1.val(release_v1);
		$release_v2.val(release_v2);

		$form.submit();
	});

});



/* episode-nav
------------------------------------*/
$(function ($) {

	const $episodeNav = $('.episode-nav');

	if ( !$episodeNav.length ) return false;

	const $select = $('.episode-nav-select');

	$select.on('change', function () {
		var href = $(this).val();

		document.location.href = href;
	});

});



/* serial
------------------------------------*/

$(function ($) {

    const $serial = $('.serial');

    if ( !$serial.length ) return false;

    $(document).on('click','.serial-btn',function(){
        if ( !$(this).hasClass('serial-loaded') ) {
            var $elem = $(this);
            var id = $elem.data('id');
            var code = $elem.data('code');
            var $video = $('#video' + id);

            $.ajax({
                url: '/personal/ajax',
                type: 'get',
                data: {id: id,code:code},
                success: function(data){
                    console.log(data);
                    $video.html(data);
                    $elem.addClass('serial-loaded');
                }
            });
        }
    });
    const $btn = $('.serial-btn');
    $btn.first().click()
});


/* comments
------------------------------------*/
$(function ($) {
    var $show_comments = $('#show_comments');
   $show_comments.click(function(){
       $.ajax({
           url: 'https://vk.com/js/api/openapi.js?159',
           dataType: 'script',
           success: function(){
               VK.init({apiId: 6695300, onlyWidgets: true});
               $('#vk_comments').parent().show();
               VK.Widgets.Comments("vk_comments", {limit: 10, attach: "*"});
               $show_comments.parent().remove();
           },
           async: true
       });
   });
});

/* editor
------------------------------------*/

$(function ($) {
    if (typeof(FroalaEditor)!='undefined'){
        var editor = new FroalaEditor('#froalaEditor', {imageUploadURL: '/upload/upload_image'});
    }
});



/* anime-show-items
------------------------------------*/

$(function ($) {

	const $animeShowItems = $('.anime-show-items');

	if ( !$animeShowItems.length ) return false;

	const $animeShowItem = $('.anime-show-item');

	$animeShowItem.on('click', function (event) {
		if (
				!$(event.target).is('.anime-show-item-visual img') &&
				!$(event.target).is('.anime-show-item-popup') &&
				!$(event.target).parents().is('.anime-show-item-popup')
		) {
			var href = $(this).attr('data-href');

			document.location.href = href;
		}
	});

});



/* carousel
------------------------------------*/
$('.carousel').carousel();



/* a[data-confirm]
------------------------------------*/
$(function ($) {

	const $confirm = $('a[data-confirm]');

	if ( !$confirm.length ) return false;

	$confirm.on('click', function (e) {
		var text = $(this).attr('data-confirm');

		if ( !confirm(text) ) {
			e.preventDefault();
			e.unbind('click');
		}
	});

});



/* a[data-method]
------------------------------------*/
$(function ($) {

	const $method = $('a[data-method]');

	if ( !$method.length ) return false;

	$method.on('click', function () {
		handleMethod($(this));

		return false;
	});

});



/* ADVERTISE
------------------------------------*/
$(function ($) {
    const isMobile = /Mobile|webOS|BlackBerry|IEMobile|MeeGo|mini|Fennec|Windows Phone|Android|iP(ad|od|hone)/i.test(navigator.userAgent);
    if (isMobile){
        $('#adv-block-desktop').remove();
    } else {
        $('#adv-block-mobile').remove();
    }
});


/* handleMethod
------------------------------------*/
function handleMethod(link) {
	var href = link.attr('href'),
		method = link.attr('data-method'),
		target = link.attr('target'),
		csrfToken = $('meta[name="csrf-token"]').attr('content'),
		csrfParam = $('meta[name="csrf-param"]').attr('content'),
		form = $('<form method="post" action="' + href + '"></form>'),
		metadataInput = '<input name="_method" value="' + method + '" type="hidden" />';

	if (csrfParam !== undefined && csrfToken !== undefined) {
		metadataInput += '<input name="' + csrfParam + '" value="' + csrfToken + '" type="hidden" />';
	}

	if (target) { form.attr('target', target); }

	form.hide().append(metadataInput).appendTo('body');
	form.submit();
}



/* is_touch_device
------------------------------------*/
function is_touch_device() {
	var prefixes = ' -webkit- -moz- -o- -ms- '.split(' ');
	var mq = function(query) {
		return window.matchMedia(query).matches;
	}

	if (('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch) {
		return true;
	}

	// include the 'heartz' as a way to have a non matching MQ to help terminate the join
	// https://git.io/vznFH
	var query = ['(', prefixes.join('touch-enabled),('), 'heartz', ')'].join('');
	return mq(query);
}


/* RATING
------------------------------------*/
$(function ($) {
    var user_id = $('body').data('user-id');
    var ratingElem = $('div#rating');
    var userRated = ratingElem.attr('data-user-rated');
    if (user_id){
        var serial_id = ratingElem.data('serial-id');
        ratingElem.raty({
            number: 10,
            path: '/raty/',
            readOnly: userRated == "true" ? true : false,
            score: function() {
                return $(this).attr('data-score');
            },
            click: function(score, ev) {
                $.ajax({
                    type: 'post',
                    url: '/serial/rate',
                    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                    data: {
                        serial_id: serial_id,
                        score: score,
                    },
                    dataType: "json",
                    success: function(result) {
                        alert('Вы успешно проголосовали!');
                        window.location.reload();
                    },
                    error: function(error) {
                        alert('Не удалось проголосовать!');
                    }
                });
            }
        });


    } else {
        ratingElem.raty({
            number: 10,
            path: '/raty/',
            readOnly: true,
            score: function() {
                return $(this).attr('data-score');
            }
        });
    }
});

/* AKA link-more
------------------------------------*/
$(function ($) {
    $(document).on('click','a.view-more',function(){
        var $a = $(this);
        var text = $a.data('text');
        $a.parent().append(text);
        $a.remove();
        return false;

    })
});

/* Expand hidden chapters
------------------------------------*/
$(function ($) {
    $('a.chapters-expand').click(function(){
        var $a = $(this);
        $a.remove();
        $('.chapters-item.hidden').removeClass('hidden');
        return false;
    });
});


/* tiny-slider
------------------------------------*/
$(function ($) {
    var $mainCharacterTab = $('#mainCharacterTab');
    if ($mainCharacterTab.length){
        setTimeout(function(){
            var mainCharacterSlider = tns({
                container: '.mainCharacterSlider',
                fixedWidth: 200,
                slideBy: 'page',
                mouseDrag: true,
                nav: false,
                controlsText: ['<span class="fa fa-chevron-circle-left"></span>', '<span class="fa fa-chevron-circle-right"></span>'],
                lazyload: true
            });

            var secondaryCharacterSlider = tns({
                container: '.secondaryCharacterSlider',
                fixedWidth: 200,
                slideBy: 'page',
                mouseDrag: true,
                nav: false,
                controlsText: ['<span class="fa fa-chevron-circle-left"></span>', '<span class="fa fa-chevron-circle-right"></span>'],
                lazyload: true
            });
            $mainCharacterTab.tab('show');
        },1000);
    }
});

/* special show data
------------------------------------*/
$(function ($) {
    $('#special_show_data').click(function(){
        $(this).remove();
        $('.special-data').show();
    });
});

/* DataTables
------------------------------------*/
$(function ($) {
    $('#serials').DataTable({});
    $('#revisions').DataTable({
        "order": []
    });
    $('#elements').DataTable({});
    $('#accounts').DataTable({});
    $('#attachments').DataTable({});
    $('#episodes').DataTable({});
    $('#comments').DataTable({
        "order": []
    });
    $('#adblock').DataTable({"order": []});
    $('#notifications').DataTable({
        "order": []
    });
});

/* Serial#edit
------------------------------------*/
var process_serial_elements = function(){
    $('#serial_elements').val($('.serial-element-block').map(function(x){return $(this).data('id')}).get().sort());
};

var process_serial_songs = function(){
    $('#serial_songs').val($('.serial-song-block').map(function(x){return $(this).data('id')}).get());
};

var process_serial_characters = function(){
    $('#serial_characters').val($('.serial-character-block').map(function(x){return $(this).data('id')}).get());
};

var process_serial_creators = function(){
    $('#serial_creators').val($('.serial-creator-block').map(function(x){return $(this).data('id')}).get());
};

var process_song_stuffs = function(){
    $('#song_stuffs').val($('.song-stuff-block').map(function(x){return $(this).data('id')}).get());
};

$(function ($) {
    $(document).on('click','.serial-element-block .remove-link',function(){
        $(this).parent().remove();
        process_serial_elements();
        return false;
    });

    $(document).on('click','.serial-song-block .remove-link',function(){
        $(this).parent().remove();
        process_serial_songs();
        return false;
    });

    $(document).on('click','.serial-character-block .remove-link',function(){
        $(this).parent().remove();
        process_serial_characters();
        return false;
    });

    $(document).on('click','.serial-creator-block .remove-link',function(){
        $(this).parent().remove();
        process_serial_creators();
        return false;
    });

    $(document).on('click','.song-stuff-block .remove-link',function(){
        $(this).parent().remove();
        process_song_stuffs();
        return false;
    });

    $(document).on('click','.remove-attachment',function(){
        if (confirm('Действительно удалить обложку?')){
            var $elem = $(this);
            $.ajax({
                type: 'post',
                url: '/moderate/remove_attachment_ajax',
                data: {
                    id: $elem.data('id')
                },
                success: function() {
                    $elem.prev().remove();
                    $elem.remove();
                }
            });
        }
        return false;
    });
});

/* AutoComplete
------------------------------------*/
$(function ($) {
    var $serial_element_search = $('#serial_element_search');
    $serial_element_search.autoComplete({resolverSettings: {url: '/element/search'}});
    $serial_element_search.on('autocomplete.select',function(event,item){
        $("span.serial-element-block[data-id="+item.id+"]").remove();
        var $elem = $('<span class="serial-element-block" data-id="'+item.id+'">'+item.value+' <a class="remove-link" href="#"><span class="badge badge-alert">X</span></a></span>');
        $('#serial_elements_'+item.elem_type).append($elem);
        $serial_element_search.autoComplete('clear');
        process_serial_elements();
    });

    var $song_relation = $('#song_relation');
    var $serial_song_search = $('#serial_song_search');
    $serial_song_search.autoComplete({resolverSettings: {url: '/song/search'}});
    $serial_song_search.on('autocomplete.select',function(event,item){
        var relation_id = parseInt($song_relation.val());
        var song_id = item.id+'-'+relation_id;
        $("span.serial-song-block[data-id="+song_id+"]").remove();
        var $elem = $('<span class="serial-song-block" data-id="'+song_id+'">'+item.text+' <a class="remove-link" href="#"><span class="badge badge-alert">X</span></a></span>');
        $('#serial_songs_'+relation_id).append($elem);
        $serial_song_search.autoComplete('clear');
        process_serial_songs();
    });

    var $character_category = $('#character_category');
    var $serial_character_search = $('#serial_character_search');
    var $serial_character_creator_search = $('#serial_character_creator_search');
    $serial_character_search.autoComplete({resolverSettings: {url: '/character/search'}});
    $serial_character_creator_search.autoComplete({resolverSettings: {url: '/creator/search'}});
    $serial_character_search.on('autocomplete.select',function(event,item){
        $serial_character_search.data('id',item.id);
        $serial_character_search.removeClass('error-control');
    });
    $serial_character_creator_search.on('autocomplete.select',function(event,item){
        $serial_character_creator_search.data('id',item.id);
        $serial_character_creator_search.removeClass('error-control');
    });
    $('#add_serial_character').click(function(){
        var creator_id = parseInt($serial_character_creator_search.data('id'));
        var character_id = parseInt($serial_character_search.data('id'));
        var character_category = parseInt($character_category.find('option:selected').val());
        if (!creator_id || !character_id || !character_category) {
            if (!creator_id) $serial_character_creator_search.addClass('error-control');
            if (!character_id) $serial_character_search.addClass('error-control');
            if (!character_category) $character_category.addClass('error-control');
            return false;
        }
        var data_id = character_id + '-' + creator_id + '-' + character_category;
        var text = $serial_character_search.val() + ' (' + $serial_character_creator_search.val() + ')';
        $("span.serial-character-block[data-id="+data_id+"]").remove();
        var $elem = $('<span class="serial-character-block" data-id="'+data_id+'">'+text+' <a class="remove-link" href="#"><span class="badge badge-alert">X</span></a></span>');
        $('#serial_characters_'+character_category).append($elem);
        $serial_character_creator_search.autoComplete('clear');
        $serial_character_search.autoComplete('clear');
        $serial_character_creator_search.removeClass('error-control');
        $serial_character_search.removeClass('error-control');
        $serial_character_creator_search.data('id',null);
        $serial_character_search.data('id',null);
        process_serial_characters();
        return false;
    });

    var $serial_creator_search = $('#serial_creator_search');
    var $serial_credit_search = $('#serial_credit_search');
    $serial_creator_search.autoComplete({resolverSettings: {url: '/creator/search'}});
    $serial_credit_search.autoComplete({resolverSettings: {url: '/credit/search'}});
    $serial_creator_search.on('autocomplete.select',function(event,item){
        $serial_creator_search.data('id',item.id);
        $serial_creator_search.removeClass('error-control');
    });
    $serial_credit_search.on('autocomplete.select',function(event,item){
        $serial_credit_search.data('id',item.id);
        $serial_credit_search.removeClass('error-control');
    });
    $('#add_serial_creator').click(function(){
        var creator_id = parseInt($serial_creator_search.data('id'));
        var credit_id = parseInt($serial_credit_search.data('id'));
        if (!creator_id || !credit_id) {
            if (!creator_id) $serial_creator_search.addClass('error-control');
            if (!credit_id) $serial_credit_search.addClass('error-control');
            return false;
        }
        var data_id = creator_id + '-' + credit_id;
        var text = $serial_creator_search.val() + ' (' + $serial_credit_search.val() + ')';
        $("span.serial-creator-block[data-id="+data_id+"]").remove();
        var $elem = $('<span class="serial-creator-block" data-id="'+data_id+'">'+text+' <a class="remove-link" href="#"><span class="badge badge-alert">X</span></a></span>');
        $('#serial_creator_items').append($elem);
        $serial_creator_search.autoComplete('clear');
        $serial_credit_search.autoComplete('clear');
        $serial_creator_search.removeClass('error-control');
        $serial_credit_search.removeClass('error-control');
        $serial_creator_search.data('id',null);
        $serial_credit_search.data('id',null);
        process_serial_creators();
        return false;
    });

    var $song_creator_search = $('#song_creator_search');
    var $song_credit_search = $('#song_credit_search');
    $song_creator_search.autoComplete({resolverSettings: {url: '/creator/search'}});
    $song_credit_search.autoComplete({resolverSettings: {url: '/credit/search'}});
    $song_creator_search.on('autocomplete.select',function(event,item){
        $song_creator_search.data('id',item.id);
        $song_creator_search.removeClass('error-control');
    });
    $song_credit_search.on('autocomplete.select',function(event,item){
        $song_credit_search.data('id',item.id);
        $song_credit_search.removeClass('error-control');
    });
    $('#add_song_stuff').click(function(){
        var creator_id = parseInt($song_creator_search.data('id'));
        var credit_id = parseInt($song_credit_search.data('id'));
        if (!creator_id || !credit_id) {
            if (!creator_id) $song_creator_search.addClass('error-control');
            if (!credit_id) $song_credit_search.addClass('error-control');
            return false;
        }
        var data_id = creator_id + '-' + credit_id;
        var text = $song_creator_search.val() + ' (' + $song_credit_search.val() + ')';
        $("span.song-stuff-block[data-id="+data_id+"]").remove();
        var $elem = $('<span class="song-stuff-block" data-id="'+data_id+'">'+text+' <a class="remove-link" href="#"><span class="badge badge-alert">X</span></a></span>');
        $('#song_stuff_items').append($elem);
        $song_creator_search.autoComplete('clear');
        $song_credit_search.autoComplete('clear');
        $song_creator_search.removeClass('error-control');
        $song_credit_search.removeClass('error-control');
        $song_creator_search.data('id',null);
        $song_credit_search.data('id',null);
        process_song_stuffs();
        return false;
    });

});

/* Favorite
------------------------------------*/
$(function ($) {
    var $favorite = $('#favorite');
    var object_type = $favorite.data('object-type');
    var object_id = $favorite.data('object-id');
    var $modal = $('#favorite_modal');
    var $favorite_comment = $('#favorite_comment');
    var $favorite_chapter_id = $('#favorite_chapter_id');
    var $favorite_add = $('#favorite_add');

    $(document).on('click','.favorited-toggle',function(){
        var $elem = $(this);
        if ($elem.data('active')===''){
            $elem.addClass('disabled');
            $.ajax({
                type: 'post',
                url: '/favorite/toggle',
                data: {
                    object_type: object_type,
                    object_id: object_id,
                    scope: $elem.data('scope')
                },
                success: function(html) {
                    $favorite.html(html);
                }
            });
        } else {
            $modal.find('h5').html('Добавление в закладки - '+$elem.data('title'));
            $favorite_add.data('scope',$elem.data('scope'));
            $modal.modal();
        }
        return false;
    });

    $favorite_add.click(function(){
        $.ajax({
            type: 'post',
            url: '/favorite/toggle',
            data: {
                object_type: object_type,
                object_id: object_id,
                scope: $favorite_add.data('scope'),
                comment: $favorite_comment.val(),
                chapter_id: $favorite_chapter_id.val()
            },
            success: function(html) {
                $favorite.html(html);
            }
        });
        $modal.modal('hide');
        $favorite_comment.val('');
        $favorite_chapter_id.val('');
    });

});

/* Admin accounts rename
------------------------------------*/
$('.account-nickname').change(function(){
    var elem = $(this);
    $.ajax({
        url: '/admin/update_account_nickname',
        type: 'post',
        data: {account_id:elem.data('id'),nickname:elem.val()},
        success: function(data){
            process_message(data.message);
            elem.addClass(data.status==='success' ? 'is-valid' : 'is-invalid');
        }
    });
});

/* Ajax tests
------------------------------------*/
$(function ($) {
    $('.images-loader-input').change(function(){
        var $elem = $(this);
        $elem.prev().text($elem.prop('files').length ? 'Выбрано файлов: '+$elem.prop('files').length : 'Добавить картинки');
    });
    var $images_loader = $('#images_loader');
    var $loader_label = $('#images_loader_label');
    var $images_loader_input = $('#images_loader_input');
    var $loaded_images = $('#loaded_images');
    $images_loader_input.change(function(){
        var fd = new FormData();
        var files = $images_loader_input.prop('files');
        for (var i=0; i< files.length; i++){
            fd.append('file'+i,files[i]);
        }
        fd.append('object_id',$images_loader.data('object-id'));
        fd.append('object_type',$images_loader.data('object-type'));
        $.ajax({
            url: '/moderate/upload_attachments_ajax',
            type: 'post',
            data: fd,
            contentType: false,
            processData: false,
            success: function(response){
                response.data.forEach(function(attachment){
                    var $img = $('<img>');
                    $img.attr('src',attachment.src);
                    $img.css('height',65);
                    if (!response.allowed) {
                        $img.addClass('attachment-is-not-applied');
                    }
                    $loaded_images.append($img);
                    if (!!response.allowed) {
                        $loaded_images.append($('<button class="btn btn-danger remove-attachment" data-id="'+attachment.id+'">X</button>'));
                    }
                });
                $images_loader_input.val('');
                $images_loader_input.prop('disabled',false);
                $loader_label.html('Добавить картинки');
                $loader_label.attr('disabled',false);
            },
        });
        $images_loader_input.prop('disabled',true);
        $loader_label.html('Загрузка...');
        $loader_label.prop('disabled',true);
    });
});

/* episode-promo
------------------------------------*/
function getCookie(name) {
    var matches = document.cookie.match(new RegExp(
        "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
    ));
    return matches ? decodeURIComponent(matches[1]) : undefined;
}

$(function ($) {
    var $promo_register = $('#promo-register');
    if (!!$promo_register.length){
        setTimeout(function(){
            $promo_register.modal({backdrop: 'static'});
        },3000);
    }

    var $promo_contest = $('#promo-contest');
    var promo_shown_times = parseInt(getCookie('promo_shown_times'))||0;
    if (!!$promo_contest.length && promo_shown_times<3){
        setTimeout(function(){
            $promo_contest.modal({backdrop: 'static'});
            document.cookie = "promo_shown_times="+(promo_shown_times+1)+"; expires=Tue, 19 Jan 2038 03:14:07 GMT";
        },3000);
    }
});

/* account
------------------------------------*/
var process_message = function(message){
    var $notice_wrapper = $('#notice_wrapper');
    var $alert = $notice_wrapper.find('.alert');
    $alert.html(message);
    $notice_wrapper.removeClass('hidden');
};

$(function ($) {
    var $nickname = $('#nickname');
    var $change_button = $('#change-nickname');
    $change_button.click(function () {
        $change_button.attr('disabled',true);
        $.ajax({
            type: 'post',
            url: '/account/change_nickname',
            data: {
                nickname: $nickname.val()
            },
            success: function(data) {
                if (data['status']==='success'){
                    $nickname.val(data['value']);
                }
                process_message(data['message']);
                $change_button.attr('disabled',false);
            }
        });
    });

    $('.notification-read').click(function(){
        var $tr = $(this).closest('tr');
        $.ajax({
            type: 'post',
            url: '/account/notification_read',
            data: {notification_id: $tr.data('id')},
            success: function(){
                $tr.remove();
            }
        })
    });
});

/* chapter
------------------------------------*/
$(function ($) {
    var $chapter_link = $('#chapter-link');
    var $create_chapter_link = $('#create-chapter-link');
    var $chapter_links = $('.chapter-links');
    $create_chapter_link.click(function () {
        $create_chapter_link.attr('disabled',true);
        $.ajax({
            type: 'post',
            url: '/serial/empty/episode/'+$chapter_link.data('id')+'/create_chapter_link',
            data: {
                link: $chapter_link.val()
            },
            success: function(data) {
                if (data['status']!=='error'){
                    $chapter_link.val('');
                }
                process_message(data['message']);
                $create_chapter_link.attr('disabled',false);
            }
        });
    });

    var $video_details = $('#video-details');
    var $video_link = $('#video-link');
    var $create_video_link = $('#create-video-link');
    var $videos = $('.videos');
    $create_video_link.click(function () {
        $create_video_link.attr('disabled',true);
        $.ajax({
            type: 'post',
            url: '/serial/empty/episode/'+$chapter_link.data('id')+'/create_chapter_video',
            data: {
                details: $video_details.val(),
                link: $video_link.val(),
            },
            success: function(data) {
                if (data['status']!=='error'){
                    $video_details.val(1);
                    $video_link.val('');
                }
                process_message(data['message']);
                $create_video_link.attr('disabled',false);
            }
        });
    });
});
/* admin seo block
------------------------------------*/
$(function ($) {
    $('#admin-seo-block-toggle').click(function () {
        $('.admin-seo-block').toggle();
    });

    $('.admin-seo-block-save').click(function () {
        data = {
            controller_name: $(this).data('controller-name'),
            action_name: $(this).data('action-name'),
            domains: {

            }
        }
        $('.admin-seo-elem').each(function(){
            let $elem = $(this);
            let domain = $(this).data('domain');
            data['domains'][domain] = {
                title: $elem.find('.seo-title').val(),
                h1: $elem.find('.seo-h1').val(),
                klass: $elem.find('.seo-klass').val(),
            }
        })
        $.ajax({
            type: 'post',
            url: '/admin/update_seo_item',
            data: data,
            success: function() {
                location.reload();
            }
        });
    });
});


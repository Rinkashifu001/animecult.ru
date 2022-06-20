$('.user-social-networks .btn.remove').click((event) => {
    let slf = $(event.currentTarget);

    if (slf.data('providerRemove'))
        return;
    else
        event.preventDefault();

    let providerKey = slf.data('providerKey');
    let providerTitle = slf.data('providerTitle');
    let successText = slf.data('successText');
    let acceptDestroyProvider = confirm(`Вы действительно хотите удалить привязку с соц. сетью ${providerTitle}?`);

    if (!acceptDestroyProvider)
        return;

    $.ajax({
        url: `/user_social_networks/${providerKey}`,
        type: 'DELETE',
        beforeSend: () => {
            slf.find('.fa').addClass('preload');
        },
        success: () => {
            slf.find('.title').text(successText);
            slf.data('providerRemove', true);
            slf.removeClass('remove');
        },
        errors: (data, status_code) => {
            alert(`Что-то пошло не так... Код ошибки: ${status_code}`);
        },
        complete: () => {
            slf.find('.fa').removeClass('preload')
        }
    })
});
function engine(){
  $("#credit-card input, #credit-card select").attr("disabled", false);

  $("form:has(#credit-card)").submit(function() {
    var form = this;
    $("#user_submit").attr("disabled", true);
    $("#credit-card input, #credit-card select").attr("name", "");
    $("#credit-card-errors").hide();

    if (!$("#credit-card").is(":visible")) {
      $("#credit-card input, #credit-card select").attr("disabled", true);
      return true;
    }

    var card = {
      number:   $("#credit_card_number").val(),
      expMonth: $("#_expiry_date_2i").val(),
      expYear:  $("#_expiry_date_1i").val(),
      cvc:      $("#cvv").val()
    };


    Stripe.createToken(card, function(status, response) {
      if (status === 200) {
        $("#user_last_4").val(response.card.last4);
        $("#user_stripe_token").val(response.id);
        form.submit();
      } else {
        $("#stripe-error-message").text(response.error.message);
        $("#credit-card-errors").show();
        $("#user_submit").attr("disabled", false);
      }
    });

    return false;
  });

  $("#change-card a").click(function() {
    $("#change-card").hide();
    $("#credit-card").show();
    $("#credit_card_number").focus();
    return false;
  });

  $('#payment-form').submit(function(event) {
    var $form = $(this);

    // Disable the submit button to prevent repeated clicks
    $form.find('button').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  });
}
//
// function stripeResponseHandler(status, response) {
//   var $form = $('#payment-form');
//
//   if (response.error) {
//     // Show the errors on the form
//     $form.find('.payment-errors').text(response.error.message);
//     $form.find('button').prop('disabled', false);
//   } else {
//     // response contains id and card, which contains additional card details
//     var token = response.id;
//     // Insert the token into the form so it gets submitted to the server
//     $form.append($('<input type="hidden" name="stripeToken" />').val(token));
//     // and submit
//     console.log("Doing something")
//     $form.get(0).submit();
//   }
// };
// $(function() {
//   $("#credit-card input, #credit-card select").attr("disabled", false);
//
//   $("form:has(#credit-card)").submit(function() {
//     var form = this;
//     $("#user_submit").attr("disabled", true);
//     $("#credit-card input, #credit-card select").attr("name", "");
//     $("#credit-card-errors").hide();
//
//     if (!$("#credit-card").is(":visible")) {
//       $("#credit-card input, #credit-card select").attr("disabled", true);
//       return true;
//     }
//
//     var card = {
//       number:   $("#credit_card_number").val(),
//       expMonth: $("#_expiry_date_2i").val(),
//       expYear:  $("#_expiry_date_1i").val(),
//       cvc:      $("#cvv").val()
//     };
//
//
//     Stripe.createToken(card, function(status, response) {
//       if (status === 200) {
//         $("#user_last_4").val(response.card.last4);
//         $("#user_stripe_token").val(response.id);
//         form.submit();
//       } else {
//         $("#stripe-error-message").text(response.error.message);
//         $("#credit-card-errors").show();
//         $("#user_submit").attr("disabled", false);
//       }
//     });
//
//     return false;
//   });
//
//   $("#change-card a").click(function() {
//     $("#change-card").hide();
//     $("#credit-card").show();
//     $("#credit_card_number").focus();
//     return false;
//   });
// });

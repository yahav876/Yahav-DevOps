#!/usr/bin/env python3

api_string = "/v1.0/plt-payment/listen/paypal/webhook-event-notify/v1.0/globalpay/vidaa/query/basic/supported-payment-methods/v1.0/globalpay/vidaa/query/subscription/get-customer-receipts/v1.0/globalpay/vidaa/query/subscription/get-customer-receipts-v2/v1.0/globalpay/vidaa/login-pay/cancel-agreement/v1.0/globalpay/vidaa/query/one-time/invoice-statement/v1.0/globalpay/vidaa/query/one-time/checkout-details/v1.0/globalpay/vidaa/query/one-time/purchase-history/v1.0/globalpay/vidaa/message/add-payment-method-on-tv/v1.0/globalpay/vidaa/query/subscription/get-customer-subscriptions/v1.0/globalpay/vidaa/basic/send-payment-addition-email/v1.0/globalpay/vidaa/query/plan/get-plans/v1.0/globalpay/vidaa/message/payment-method-collected-on-mobile/v1.0/globalpay/vidaa/payment-method/rules/v1.0/globalpay/listen/csp/verifyPaymentReceipt/v1.0/globalpay/vidaa/basic/get-payment-fields/v1.0/globalpay//vidaa/query/basic/currency-alias/v1.0/globalpay/vidaa/query/basic/supported-apps/v1.0/globalpay/vidaa/subscription/reactive/v1.0/globalpay/vidaa/payment-method/payment-method-available/v1.0/globalpay/vidaa/subscription/has-valid-subscriptions/v1.0/globalpay/vidaa/payment-method/list/v1.0/globalpay/vidaa/subscription/unsubscribe/v1.0/globalpay/vidaa/one-time/purchase/v1.0/globalpay/vidaa/plan/plan-price/v1.0/globalpay/vidaa/basic/pin-check/v1.0/globalpay/vidaa/basic/supportsPayment/v1.0/globalpay/vidaa/query/plan/sub-plans/v1.0/globalpay/vidaa/query/subscription/get-support-info/v1.0/globalpay/vidaa/payment-method/refresh/v1.0/globalpay/vidaa/query/internal/one-time/my-current-purchase/v1.0/globalpay/vidaa/payment-method/country/list/v1.0/globalpay/vidaa/payment-method/remove/v1.0/globalpay/vidaa/basic/get-payment-term/v1.0/globalpay/vidaa/query/plan/loading-images/v1.0/globalpay/vidaa/subscription/subscribe/v1.0/globalpay/vidaa/query/basic/zipcode-collect-flag/v1.0/globalpay/vidaa/basic/valid-zip-code/v1.0/globalpay/vidaa/login-pay/get-pay-qr-on-tv/v1.0/globalpay/vidaa/login-pay/get-pay-login-url/v1.0/globalpay/vidaa/login-pay/get-h5-pay-login-url/v1.0/globalpay/vidaa/login-pay/agreement/v1.0/globalpay/vidaa/login-pay/get-pay-platform-account/v1.0/globalpay/vidaa/login-pay/is-already-linked/v1.0/globalpay/vidaa/basic/send-qr-link-email/v1.0/globalpay/vidaa/query/basic/provinces/v1.0/globalpay/vidaa/login-pay/save-credit-card/plt-payment/common/cc/get-cc-client-key/v1.0/globalpay/vidaa/login-pay/save-credit-card-web/v1.0/globalpay/vidaa/payment-method/get-cc-addition-tv-req/v1.0/globalpay-query/subscription/status/v1.0/globalpay-query/subscription/status-wo-pollId"

api_list = []

# Split the big string into individual API paths
while api_string.startswith("/v1"):
    index = api_string.find("/v1", 1)
    if index == -1:
        api_list.append([api_string, 0.5])
        break
    else:
        api_list.append([api_string[:index], 0.5])
        api_string = api_string[index:]

print(api_list)

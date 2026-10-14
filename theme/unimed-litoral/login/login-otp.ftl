<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section="header">
        ${msg("loginOtpTitle")}
    <#elseif section="subtitle">
        ${msg("loginOtpSubtitle")}
    <#elseif section="form">
        <form id="kc-otp-login-form" class="${properties.kcFormClass!} ul-form--fill" action="${url.loginAction}" method="post">
            <#if otpLogin.userOtpCredentials?size gt 1>
                <fieldset class="ul-tiles">
                    <legend class="${properties.kcLabelClass!}">${msg("unimedOtpDevice")}</legend>
                    <#list otpLogin.userOtpCredentials as otpCredential>
                        <input id="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListInputClass!}" type="radio" name="selectedCredentialId" value="${otpCredential.id}" <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>>
                        <label for="kc-otp-credential-${otpCredential?index}" class="${properties.kcLoginOTPListClass!}">
                            <span class="${properties.kcLoginOTPListItemIconClass!}" aria-hidden="true"></span>
                            <span class="${properties.kcLoginOTPListItemTitleClass!}">${otpCredential.userLabel}</span>
                        </label>
                    </#list>
                </fieldset>
            </#if>

            <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('totp')> ${properties.kcFormGroupErrorClass!}</#if>">
                <label for="otp" class="${properties.kcLabelClass!} ul-sr-only">${msg("loginOtpOneTime")}</label>
                <#-- Campo real (enviado ao servidor). O JS troca por 6 caixas; sem JS ele continua utilizável. -->
                <input id="otp" name="otp" autocomplete="one-time-code" type="text" inputmode="numeric" maxlength="8"
                       class="${properties.kcInputClass!} ul-otp-input" data-otp-digits="${(otpLogin.policy.digits)!6}"
                       autofocus aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" dir="ltr" />
                <#if messagesPerField.existsError('totp')>
                    <span id="input-error-otp-code" class="${properties.kcInputErrorMessageClass!} ul-center" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                    </span>
                </#if>
            </div>

            <p class="ul-center ul-muted">${msg("loginOtpHelp")}</p>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!} ul-buttons--pair">
                <a class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!}" href="${url.loginRestartFlowUrl}">${msg("doBack")}</a>
                <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!}" name="login" id="kc-login" type="submit" value="${msg("doContinue")}" />
            </div>
        </form>
        <script type="module" src="${url.resourcesPath}/js/unimed-otp.js"></script>
    </#if>
</@layout.registrationLayout>

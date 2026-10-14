<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false displayMessage=!messagesPerField.existsError('username') steps=2 currentStep=1; section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "subtitle">
        <#if realm.duplicateEmailsAllowed>
            ${msg("emailInstructionUsername")}
        <#else>
            ${msg("emailInstruction")}
        </#if>
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!} ul-form--fill" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('username')> ${properties.kcFormGroupErrorClass!}</#if>">
                <label for="username" class="${properties.kcLabelClass!}"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                <input type="text" id="username" name="username" class="${properties.kcInputClass!}" autofocus value="${(auth.attemptedUsername!'')}"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                       <#if messagesPerField.existsError('username')>aria-describedby="input-error-username"</#if> dir="ltr"/>
                <#if messagesPerField.existsError('username')>
                    <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('username'))?no_esc}
                    </span>
                </#if>
            </div>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!} ul-buttons--pair">
                <a class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!}" href="${url.loginUrl}">${msg("backToLogin")}</a>
                <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!}" type="submit" value="${msg("doContinue")}"/>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

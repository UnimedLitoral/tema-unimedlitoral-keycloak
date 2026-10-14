<#import "template.ftl" as layout>
<#import "password-commons.ftl" as passwordCommons>
<#--
  Requisitos exibidos ao usuário: lidos da política de senha do realm quando o
  Keycloak expõe "passwordPolicies"; senão usa o tamanho mínimo padrão (8).
  A verificação ao vivo (JS) é só uma ajuda visual: quem valida de fato é o servidor.
-->
<#assign pp = (passwordPolicies)!{}>
<#assign minLength = (pp.length)!8>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "subtitle">
        ${msg("updatePasswordSubtitle")}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('password')> ${properties.kcFormGroupErrorClass!}</#if>">
                <label for="password-new" class="${properties.kcLabelClass!}">${msg("passwordNew")}</label>
                <div class="${properties.kcInputGroup!}" dir="ltr">
                    <input type="password" id="password-new" name="password-new" class="${properties.kcInputClass!}"
                           autofocus autocomplete="new-password" aria-describedby="ul-password-rules"
                           aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                    />
                    <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                            aria-controls="password-new" data-password-toggle
                            data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                        <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                    </button>
                </div>
                <#if messagesPerField.existsError('password')>
                    <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('password'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('password-confirm')> ${properties.kcFormGroupErrorClass!}</#if>">
                <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
                <div class="${properties.kcInputGroup!}" dir="ltr">
                    <input type="password" id="password-confirm" name="password-confirm" class="${properties.kcInputClass!}"
                           autocomplete="new-password"
                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                    />
                    <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                            aria-controls="password-confirm" data-password-toggle
                            data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                        <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                    </button>
                </div>
                <#if messagesPerField.existsError('password-confirm')>
                    <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                    </span>
                </#if>
            </div>

            <ul id="ul-password-rules" class="ul-rules" aria-live="polite">
                <li data-rule="length" data-value="${minLength?c}">${msg("unimedRuleLength", minLength?c)}</li>
                <#if (pp.digits)?? && pp.digits gt 0><li data-rule="digits" data-value="${pp.digits?c}">${msg((pp.digits gt 1)?then("unimedRuleDigitsPlural","unimedRuleDigits"), pp.digits?c)}</li></#if>
                <#if (pp.upperCase)?? && pp.upperCase gt 0><li data-rule="upperCase" data-value="${pp.upperCase?c}">${msg((pp.upperCase gt 1)?then("unimedRuleUpperPlural","unimedRuleUpper"), pp.upperCase?c)}</li></#if>
                <#if (pp.lowerCase)?? && pp.lowerCase gt 0><li data-rule="lowerCase" data-value="${pp.lowerCase?c}">${msg((pp.lowerCase gt 1)?then("unimedRuleLowerPlural","unimedRuleLower"), pp.lowerCase?c)}</li></#if>
                <#if (pp.specialChars)?? && pp.specialChars gt 0><li data-rule="specialChars" data-value="${pp.specialChars?c}">${msg((pp.specialChars gt 1)?then("unimedRuleSpecialPlural","unimedRuleSpecial"), pp.specialChars?c)}</li></#if>
                <li data-rule="notUsername">${msg("unimedRuleNotUsername")}</li>
                <li data-rule="match">${msg("unimedRuleMatch")}</li>
            </ul>

            <@passwordCommons.logoutOtherSessions/>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}<#if isAppInitiatedAction??> ul-buttons--pair<#else> ul-buttons--end</#if>">
                <#if isAppInitiatedAction??>
                    <button class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!}" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
                    <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!}" type="submit" value="${msg("doContinue")}" />
                <#else>
                    <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!}" type="submit" value="${msg("doContinue")}" />
                </#if>
            </div>
        </form>
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
        <script type="module" src="${url.resourcesPath}/js/unimed-password-rules.js"></script>
    </#if>
</@layout.registrationLayout>

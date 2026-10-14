// Troca o campo único de OTP por N caixas (uma por dígito), como no app.
// O campo original continua sendo o que vai no POST (name="otp").
const real = document.getElementById("otp");

if (real) {
  const digits = Math.min(Math.max(Number(real.dataset.otpDigits) || 6, 4), 8);
  const group = document.createElement("div");
  group.className = "ul-otp";
  group.setAttribute("role", "group");
  group.setAttribute("aria-labelledby", real.labels?.[0]?.id || "");

  const boxes = Array.from({ length: digits }, (_, i) => {
    const box = document.createElement("input");
    box.type = "text";
    box.inputMode = "numeric";
    box.autocomplete = i === 0 ? "one-time-code" : "off";
    box.className = "ul-otp__box";
    box.setAttribute("aria-label", `Dígito ${i + 1} de ${digits}`);
    if (real.getAttribute("aria-invalid") === "true") box.setAttribute("aria-invalid", "true");
    group.appendChild(box);
    return box;
  });

  const sync = () => {
    boxes.forEach((b) => { b.dataset.prev = b.value; });
    real.value = boxes.map((b) => b.value).join("");
  };

  const fill = (start, text) => {
    const chars = text.replace(/\D/g, "").split("");
    let i = start;
    for (const c of chars) { if (i >= digits) break; boxes[i++].value = c; }
    sync();
    boxes[Math.min(i, digits - 1)].focus();
    if (real.value.length === digits) real.form.querySelector("[type=submit][name=login]")?.focus();
  };

  boxes.forEach((box, i) => {
    box.addEventListener("input", () => {
      // Sem maxlength para aceitar autopreenchimento/colagem do código inteiro;
      // ao digitar sobre um dígito existente, fica só o novo caractere.
      const prev = box.dataset.prev || "";
      let v = box.value;
      if (prev && v.length > 1) v = v.startsWith(prev) ? v.slice(prev.length) : v.endsWith(prev) ? v.slice(0, -prev.length) : v;
      box.value = "";
      if (v) fill(i, v); else sync();
    });
    box.addEventListener("keydown", (e) => {
      if (e.key === "Backspace" && !box.value && i > 0) { boxes[i - 1].value = ""; boxes[i - 1].focus(); sync(); e.preventDefault(); }
      if (e.key === "ArrowLeft" && i > 0) boxes[i - 1].focus();
      if (e.key === "ArrowRight" && i < digits - 1) boxes[i + 1].focus();
    });
    box.addEventListener("paste", (e) => { e.preventDefault(); fill(i, e.clipboardData.getData("text")); });
    box.addEventListener("focus", () => box.select());
  });

  real.type = "hidden";
  real.removeAttribute("autofocus");
  real.insertAdjacentElement("afterend", group);
  // Associa o rótulo à primeira caixa para leitores de tela.
  const label = document.querySelector('label[for="otp"]');
  if (label) { label.id = label.id || "ul-otp-label"; group.setAttribute("aria-labelledby", label.id); }
  boxes[0].focus();
}

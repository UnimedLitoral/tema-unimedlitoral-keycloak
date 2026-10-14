// Marca, ao vivo, os requisitos de senha atendidos (apenas ajuda visual;
// a validação definitiva é feita pela política de senha do Keycloak).
const list = document.getElementById("ul-password-rules");
const pwd = document.getElementById("password-new");
const confirm = document.getElementById("password-confirm");
const username = (document.getElementById("kc-attempted-username")?.textContent || "").trim().toLowerCase();

const count = (value, re) => (value.match(re) || []).length;
const checks = {
  length: (v, n) => v.length >= n,
  digits: (v, n) => count(v, /\d/g) >= n,
  upperCase: (v, n) => count(v, /\p{Lu}/gu) >= n,
  lowerCase: (v, n) => count(v, /\p{Ll}/gu) >= n,
  specialChars: (v, n) => count(v, /[^\p{L}\p{N}]/gu) >= n,
  notUsername: (v) => v.length > 0 && (!username || v.toLowerCase() !== username),
  match: (v) => v.length > 0 && v === confirm.value,
};

function update() {
  const value = pwd.value;
  list.querySelectorAll("li[data-rule]").forEach((li) => {
    const fn = checks[li.dataset.rule];
    if (!fn) return;
    li.classList.toggle("ul-rules__ok", fn(value, Number(li.dataset.value || 0)));
  });
}

if (list && pwd && confirm) {
  pwd.addEventListener("input", update);
  confirm.addEventListener("input", update);
  update();
}

// Troca de telas (abas)
const abas = document.querySelectorAll("nav button");
const telas = document.querySelectorAll(".tab");

abas.forEach((aba) => {
  aba.addEventListener("click", () => {
    abas.forEach((b) => b.classList.remove("active"));
    telas.forEach((t) => t.classList.remove("active"));
    aba.classList.add("active");
    document.getElementById(aba.dataset.tab).classList.add("active");
  });
});

// Simulação do botão de gravação (sem backend)
const status = document.getElementById("status");
document.getElementById("btn-iniciar").addEventListener("click", () => {
  status.textContent = "Gravando";
});
document.getElementById("btn-parar").addEventListener("click", () => {
  status.textContent = "Não gravando";
});
<?php defined('BASE_PATH') || exit('Acesso direto nao permitido.'); ?>

<section class="dashboard-shell">
    <div class="dashboard-heading">
        <span class="eyebrow">Aluno</span>
        <h1>Olá, <?= e($user['full_name']) ?></h1>
        <p>Seu espaço inicial para cursos, atividades, biblioteca, eventos e evolução acadêmica.</p>
    </div>

    <div class="metric-grid">
        <article class="metric"><span>Cursos ativos</span><strong>0</strong></article>
        <article class="metric"><span>XP</span><strong>0</strong></article>
        <article class="metric"><span>Atividades</span><strong>0</strong></article>
        <article class="metric"><span>Certificados</span><strong>0</strong></article>
    </div>

    <div class="module-grid">
        <article class="module-card"><h2>Minha aprendizagem</h2><p>Cursos, aulas, materiais e progresso aparecerão aqui.</p></article>
        <article class="module-card"><h2>Comunidade</h2><p>Projetos, publicações e comentários com moderação acadêmica.</p></article>
        <article class="module-card"><h2>Biblioteca</h2><p>Livros, PDFs, apostilas e favoritos em construção.</p></article>
    </div>
</section>

<?php defined('BASE_PATH') || exit('Acesso direto nao permitido.'); ?>

<section class="dashboard-shell">
    <div class="dashboard-heading">
        <span class="eyebrow">Administrador</span>
        <h1>Administração TME</h1>
        <p>Controle inicial de usuários, permissões, aprovações, instituições e módulos da plataforma.</p>
    </div>

    <div class="metric-grid">
        <article class="metric"><span>Contas pendentes</span><strong><?= e($counts['pending_users']) ?></strong></article>
        <article class="metric"><span>Usuários aprovados</span><strong><?= e($counts['approved_users']) ?></strong></article>
        <article class="metric"><span>Cursos</span><strong><?= e($counts['courses']) ?></strong></article>
        <article class="metric"><span>Eventos</span><strong><?= e($counts['events']) ?></strong></article>
    </div>

    <div class="module-grid">
        <article class="module-card"><h2>Aprovação de contas</h2><p>Cadastros de alunos e professores entram como pendentes.</p><a href="<?= e(url('/admin/contas-pendentes')) ?>">Abrir fila</a></article>
        <article class="module-card"><h2>Permissões</h2><p>Roles e permissões já estão modelados para expansão.</p></article>
        <article class="module-card"><h2>Instituições</h2><p>Base preparada para INEP, e-MEC e cadastro manual.</p></article>
    </div>
</section>

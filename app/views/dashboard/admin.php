<?php defined('BASE_PATH') || exit('Acesso direto nao permitido.'); ?>

<section class="dashboard-shell">
    <div class="dashboard-heading">
        <span class="eyebrow">Administrador</span>
        <h1>Administracao TME</h1>
        <p>Controle inicial de usuarios, permissoes, aprovacoes, cursos, atividades, biblioteca e matriculas.</p>
    </div>

    <div class="metric-grid">
        <article class="metric"><span>Contas pendentes</span><strong><?= e($counts['pending_users']) ?></strong></article>
        <article class="metric"><span>Usuarios aprovados</span><strong><?= e($counts['approved_users']) ?></strong></article>
        <article class="metric"><span>Cursos</span><strong><?= e($counts['courses']) ?></strong></article>
        <article class="metric"><span>Certificados</span><strong><?= e($counts['certificates']) ?></strong></article>
    </div>

    <div class="module-grid">
        <article class="module-card"><h2>Aprovacao de contas</h2><p>Cadastros de alunos e professores entram como pendentes.</p><a href="<?= e(url('/admin/contas-pendentes')) ?>">Abrir fila</a></article>
        <article class="module-card"><h2>Cursos</h2><p>Crie cursos, modulos, aulas e materiais com filtros administrativos.</p><a href="<?= e(url('/admin/cursos')) ?>">Gerenciar cursos</a></article>
        <article class="module-card"><h2>Matriculas</h2><p>Veja alunos matriculados, status e progresso por curso.</p><a href="<?= e(url('/admin/matriculas')) ?>">Ver matriculas</a></article>
        <article class="module-card"><h2>Atividades</h2><p>Crie tarefas e corrija entregas com nota e feedback.</p><a href="<?= e(url('/admin/atividades')) ?>">Gerenciar atividades</a></article>
        <article class="module-card"><h2>Biblioteca</h2><p>Modere materiais enviados e gerencie publicacoes.</p><a href="<?= e(url('/admin/biblioteca')) ?>">Gerenciar biblioteca</a></article>
        <article class="module-card"><h2>Certificados</h2><p>Liste certificados emitidos e revogue registros invalidos.</p><a href="<?= e(url('/admin/certificados')) ?>">Gerenciar certificados</a></article>
        <article class="module-card"><h2>Ranking</h2><p>Veja XP, niveis, moedas e badges da comunidade.</p><a href="<?= e(url('/ranking')) ?>">Abrir ranking</a></article>
    </div>
</section>

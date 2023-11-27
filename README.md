# MedGen: Sistema de controle de estoque de medicamentos
Projeto final da disciplina OOP.

# Descrição
O MedGen é uma aplicação web com o intuito de automatizar o controle de estoque de medicamentos em uma farmácia. Possui como funcionalidades básicas o controle de acesso, a adição de medicamentos, o histórico de edições, o histórico de vendas, o cadastro de fornecedores, a busca por categoria de medicamento e a adição de usuários com diferentes níveis de acesso.

  # Funcionalidades Principais
* # Controle de Acesso
O controle de acesso permite que apenas usuários cadastrados acessem o sistema, além de permitir com que diferentes usuários possuam níveis específicos de permissão - Admin e User - garantindo que algumas funcionalidades do sistema fiquem restritas ao Admin.

* # Adição de Medicamentos
Adicione novos medicamentos no estoque, fornecendo informações como nome, categoria medicamentosa, quantidade, preço, data de validade e fornecedor responsável pelo lote. É possível também editar as informações previamente adicionadas, além de deletar a adição caso necessário.

* # Filtros na Musca por Medicamentos
Ao pesquisar por um medicamento específico, é possível filtrar escrevendo a categoria a que o medicamento pertence, facilitando a busca por um medicamento específico da lista. Outro recurso é de filtrar por data de validade do medicamento, podendo ordenar por ordem decrescente ou crescente de validade.

* # Venda de Medicamentos
Na página principal, é possível ver a lista de medicamentos e vendê-los; Quando a venda é realizada, a quantidade vendida inserida será descontada do estoque.

* # Histórico de Edição
Aba que permite ver o medicamento que foi editado, que usuário editou e a data da edição.

* # Histórico de Venda
Aba que permite ver o histórico de venda do medicamento, mostrando o usuário que vendeu, o preço, a quantidade vendida, o medicamento vendido, a data de venda e o preço total da venda calculado.

* # Adição de Usuários
O administrador consegue adicionar novos usuários ao sistema e atribui a ele um dos dois níveis de acesso - Admin ou User.

* # Cadastro de Fornecedores
Permite que fornecedores sejam cadastrados, inserindo informações como nome, endereço, telefone, e-mail e CNPJ. Permite também que haja a edição das informações ou a exclusão de umm fornecedor.

# Instalação
1. Clone ou baixe o repositório
2. Certifique-se se o servidor GlassFish inicializou ou se está presente. 
3. Execute o programa em uma IDE, de preferencia o NetBeans versão 17, 18 ou 19, com jdk 17, 18, 19 ou 20 instalado.

# Uso inicial
1. Faça login utilizando o primeiro acesso "admin" com senha "1234" para acessar o sistema.
2. Cadastre novos usuários para acessar o sistema.

# Tecnologias utilizadas
* JavaEE
* SQLite
* JSON
* GlassFish
* BootStrap
* Vue



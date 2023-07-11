select * from DimStore
--essa linha seleciona a tabela de Lojas
select StoreName as 'NomeLoja', StoreDescription as 'DescricaoLoja', Status, AddressLine1 as 'Endereco' from DimStore

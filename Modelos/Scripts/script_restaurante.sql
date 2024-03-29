DROP DATABASE IF EXISTS modelo_restaurante;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';



-- -----------------------------------------------------
-- Schema modelo_restaurante
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `modelo_restaurante` DEFAULT CHARACTER SET utf8 ;
USE `modelo_restaurante` ;


-- -----------------------------------------------------
-- Tabela 'Mesa'
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Mesa` (
  `mesa_id` VARCHAR(2) NOT NULL COMMENT 'PK da tabela \'Mesa\'',
  PRIMARY KEY (`mesa_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela 'Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Cliente` (
  `cliente_id` INT NOT NULL COMMENT 'PK da tabela \'Cliente\'',
  `Mesa_id` VARCHAR(4) NOT NULL COMMENT 'FK da tabela \'Cliente\'. Não pode ser nula. Deve ter dois digitos',
  `nome` VARCHAR(45) NULL COMMENT 'Nome do Cliente',
  `cpf` VARCHAR(14) NULL COMMENT 'CPF do Cliente',
  PRIMARY KEY (`cliente_id`),
  INDEX `fk_Cliente_Mesa1_idx` (`Mesa_id` ASC) VISIBLE,
  CONSTRAINT `fk_Cliente_Mesa1`
    FOREIGN KEY (`Mesa_id`)
    REFERENCES `modelo_restaurante`.`Mesa` (`mesa_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela 'Atendente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Atendente` (
  `matricula` VARCHAR(4) NOT NULL COMMENT 'PK da tabela \'Atendente\'. Deve ter 3 digitos',
  `nome` VARCHAR(45) NOT NULL,
  `salario` FLOAT NOT NULL COMMENT 'Salário do do atendente não pode zero e nem nulo',
  PRIMARY KEY (`matricula`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela 'Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Pedido` (
  `numero` INT NOT NULL AUTO_INCREMENT COMMENT 'PK da tabela \'Pedido\'',
  `Cliente_id` INT NOT NULL COMMENT 'FK da tabela \'Pedido\'',
  `Mesa_id` VARCHAR(2) NOT NULL COMMENT 'FK da tabela \'Pedido\'',
  `Atendente_id` VARCHAR(3) NOT NULL COMMENT 'FK da tabela \'Pedido\'',
  `start_date` DATETIME NOT NULL COMMENT 'Hora de início do pedido. Não pode ser nem nulo',
  `end_date` DATETIME NOT NULL COMMENT 'Hora do fim do pedido. Não pode ser nulo',
  `duracao` DATETIME GENERATED ALWAYS AS (end_date - start_date) VIRTUAL COMMENT 'Duraçao em segundos do pedido. Não pode ser nulo',
  `valor_total` FLOAT NULL COMMENT 'Valor total do pedido não pode ser negativo',
  PRIMARY KEY (`numero`),
  INDEX `fk_Pedido_Mesa1_idx` (`Mesa_id` ASC) VISIBLE,
  INDEX `fk_Pedido_Atendente1_idx` (`Atendente_id` ASC) VISIBLE,
  INDEX `fk_Pedido_Cliente1_idx` (`Cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Mesa1`
    FOREIGN KEY (`Mesa_id`)
    REFERENCES `modelo_restaurante`.`Mesa` (`mesa_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Atendente1`
    FOREIGN KEY (`Atendente_id`)
    REFERENCES `modelo_restaurante`.`Atendente` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_id`)
    REFERENCES `modelo_restaurante`.`Cliente` (`cliente_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela 'Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Telefone` (
  `Atendente_id` VARCHAR(3) NOT NULL COMMENT 'PFK composta da tabela \'Telefone\'',
  `telefone` VARCHAR(45) NOT NULL COMMENT 'PK composta da tabela \'Telefone\'',
  PRIMARY KEY (`Atendente_id`, `telefone`),
  INDEX `fk_Telefone_Atendente_idx` (`Atendente_id` ASC) VISIBLE,
  CONSTRAINT `fk_Telefone_Atendente`
    FOREIGN KEY (`Atendente_id`)
    REFERENCES `modelo_restaurante`.`Atendente` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Endereco` (
  `Cliente_id` INT NOT NULL COMMENT 'PFK composta da tabela \'Endereco\'',
  `endereco_id` VARCHAR(45) NOT NULL COMMENT 'PK composta da tabela \'Endereco\'',
  `UF` VARCHAR(2) NULL COMMENT 'UF do endereço',
  `cidade` VARCHAR(45) NULL COMMENT 'Cidade do endereço',
  `logradouro` VARCHAR(45) NULL COMMENT 'Logradouro do endereço',
  `numero` VARCHAR(45) NULL COMMENT 'Numero do endereço',
  `complemento` VARCHAR(45) NULL COMMENT 'Complemento do endereço',
  INDEX `fk_Endereco_Cliente1_idx` (`Cliente_id` ASC) VISIBLE,
  PRIMARY KEY (`Cliente_id`, `endereco_id`),
  CONSTRAINT `fk_Endereco_Cliente1`
    FOREIGN KEY (`Cliente_id`)
    REFERENCES `modelo_restaurante`.`Cliente` (`cliente_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Item` (
  `nome` VARCHAR(45) NOT NULL COMMENT 'PK da tabela \'Item\'',
  `preco` FLOAT NOT NULL COMMENT 'Preço do item não pode ser zero e nem nulo',
  `tipo` VARCHAR(45) NOT NULL COMMENT 'Tipo do pedido são \"COMIDA\" ou \"BEBIDA\"  e não pode ser nulo',
  PRIMARY KEY (`nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Item_Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_restaurante`.`Item_Pedido` (
  `Pedido_numero` INT NOT NULL COMMENT 'PKF da tabela \'Item_Pedido\'',
  `Item_nome` VARCHAR(45) NOT NULL COMMENT 'FK da tabela \'Item_Pedido\'',
  `quantidade` INT NOT NULL COMMENT 'A quantidade não pode ser zero e nem nula',
  PRIMARY KEY (`Pedido_numero`),
  INDEX `fk_Pedido_has_Item_Item1_idx` (`Item_nome` ASC) VISIBLE,
  INDEX `fk_Pedido_has_Item_Pedido1_idx` (`Pedido_numero` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_has_Item_Pedido1`
    FOREIGN KEY (`Pedido_numero`)
    REFERENCES `modelo_restaurante`.`Pedido` (`numero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_has_Item_Item1`
    FOREIGN KEY (`Item_nome`)
    REFERENCES `modelo_restaurante`.`Item` (`nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- CHECKS
-- -----------------------------------------------------

ALTER TABLE modelo_restaurante.Atendente
ADD CONSTRAINT salario_nao_zero
CHECK (salario > 0);

ALTER TABLE modelo_restaurante.Mesa
ADD CONSTRAINT mesa_nao_zero
CHECK (mesa_id > 0);

ALTER TABLE modelo_restaurante.Pedido
ADD CONSTRAINT valor_total_nao_zero
CHECK (valor_total >= 0);

ALTER TABLE modelo_restaurante.Item_Pedido
ADD CONSTRAINT qntd_nao_zero
CHECK (quantidade > 0);

ALTER TABLE modelo_restaurante.Item
ADD CONSTRAINT preco_nao_zero
CHECK (preco > 0);

ALTER TABLE modelo_restaurante.Item
ADD CONSTRAINT tipo_comida_bebida
CHECK (tipo IN('BEBIDA', 'COMIDA'));

ALTER TABLE modelo_restaurante.Mesa
ADD CONSTRAINT check_mesa_length 
CHECK (LENGTH(mesa_id) = 2);

ALTER TABLE modelo_restaurante.Atendente
ADD CONSTRAINT check_matricula_length 
CHECK (LENGTH(matricula) = 3);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
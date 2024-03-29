DROP DATABASE IF EXISTS modelo_universidade;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';



-- -----------------------------------------------------
-- Schema modelo_universidade
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `modelo_universidade` DEFAULT CHARACTER SET utf8 ;
USE `modelo_universidade` ;


-- -----------------------------------------------------
-- Tabela `Professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Professor` (
  `matricula` VARCHAR(4) NOT NULL COMMENT 'PK da tabela \'Professor\'. A matrícula deve ter 4 digitos',
  `email` VARCHAR(45) NOT NULL COMMENT 'Email do professor. Não pode ser nulo',
  `nome` VARCHAR(45) NULL COMMENT 'Nome do Professor',
  PRIMARY KEY (`matricula`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Curso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Curso` (
  `curso_id` INT NOT NULL COMMENT 'PK da tabela \'Curso\'',
  `coordernador` VARCHAR(4) NOT NULL COMMENT 'FK da tabela \'Curso\'. Não pode ser nulo.',
  `carga_horaria` INT(4) NOT NULL COMMENT 'Carga horária do curso. Horário fixo de 3600 horas. Não pode ser nulo',
  `nome` VARCHAR(45) NULL COMMENT 'Nome do curso',
  PRIMARY KEY (`curso_id`),
  INDEX `fk_Curso_Professor1_idx` (`coordernador` ASC) VISIBLE,
  CONSTRAINT `fk_Curso_Professor1`
    FOREIGN KEY (`coordernador`)
    REFERENCES `modelo_universidade`.`Professor` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Materia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Materia` (
  `materia_id` INT NOT NULL COMMENT 'PK da tabela \'Materia\'',
  `carga_horaria` INT NOT NULL COMMENT 'Carga horária da matéria. Não pode ser nula e deve ter no minímo 40h',
  `nome` VARCHAR(45) NULL COMMENT 'Nome da materia',
  PRIMARY KEY (`materia_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Disciplina` (
  `disciplina_id` INT NOT NULL COMMENT 'PK da tabela \'Disciplina\'',
  `materia_id` INT NULL COMMENT 'FK da tabela \'Disciplina\'',
  `professor_matricula` VARCHAR(4) NULL COMMENT 'FK da tabela \'Disciplina\'',
  `qtd_vagas` INT(2) NOT NULL COMMENT 'Quantidade de vagas na disciplina. Pode ter no maximo 60 alunos. Não pode ser nulo',
  `semestre` VARCHAR(1) NOT NULL COMMENT 'Semetre que a disciplina esta Semetre que a disciplina esta ocorrendo \'1\' para o primeiro semestre ou \'2\'  para o segundo. Não pode ser nulo',
  PRIMARY KEY (`disciplina_id`),
  INDEX `fk_Disciplina_Materia1_idx` (`materia_id` ASC) VISIBLE,
  INDEX `fk_Disciplina_Professor1_idx` (`professor_matricula` ASC) VISIBLE,
  CONSTRAINT `fk_Disciplina_Materia1`
    FOREIGN KEY (`materia_id`)
    REFERENCES `modelo_universidade`.`Materia` (`materia_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Disciplina_Professor1`
    FOREIGN KEY (`professor_matricula`)
    REFERENCES `modelo_universidade`.`Professor` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Aluno`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Aluno` (
  `matricula` INT(9) NOT NULL COMMENT 'PK da tabela \'Aluno\'. Matricula é um atributo único',
  `nome_aluno` VARCHAR(45) NULL COMMENT 'Nome do aluno',
  `curso_id` INT NULL COMMENT 'FK da tabela \'Aluno\'',
  PRIMARY KEY (`matricula`),
  INDEX `fk_Aluno_Curso1_idx` (`curso_id` ASC) VISIBLE,
  UNIQUE INDEX `matricula_UNIQUE` (`matricula` ASC) VISIBLE,
  CONSTRAINT `fk_Aluno_Curso1`
    FOREIGN KEY (`curso_id`)
    REFERENCES `modelo_universidade`.`Curso` (`curso_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Email`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Email` (
  `aluno_matricula` INT(9) NOT NULL COMMENT 'PFK composta da tabela \'Email\' ',
  `email` VARCHAR(45) NOT NULL COMMENT 'PK composta da tabela \'Email\' ',
  PRIMARY KEY (`aluno_matricula`, `email`),
  INDEX `fk_Email_Aluno1_idx` (`aluno_matricula` ASC) VISIBLE,
  CONSTRAINT `fk_Email_Aluno1`
    FOREIGN KEY (`aluno_matricula`)
    REFERENCES `modelo_universidade`.`Aluno` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Aluno_Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Aluno_Disciplina` (
  `aluno_matricula` INT(9) NOT NULL COMMENT 'PFK composta da tabela \'Aluno_Disciplina\'',
  `disciplina_id` INT NOT NULL COMMENT 'PFK composta da tabela \'Aluno_Disciplina\'',
  PRIMARY KEY (`aluno_matricula`, `disciplina_id`),
  INDEX `fk_Aluno_has_Disciplina_Disciplina1_idx` (`disciplina_id` ASC) VISIBLE,
  INDEX `fk_Aluno_has_Disciplina_Aluno1_idx` (`aluno_matricula` ASC) VISIBLE,
  CONSTRAINT `fk_Aluno_has_Disciplina_Aluno1`
    FOREIGN KEY (`aluno_matricula`)
    REFERENCES `modelo_universidade`.`Aluno` (`matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aluno_has_Disciplina_Disciplina1`
    FOREIGN KEY (`disciplina_id`)
    REFERENCES `modelo_universidade`.`Disciplina` (`disciplina_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Tabela `Curso_Materia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `modelo_universidade`.`Curso_Materia` (
  `curso_id` INT NOT NULL COMMENT 'PFK composta da tabela \'Curso_Materia\'\'',
  `materia_id` INT NOT NULL COMMENT 'PFK composta da tabela \'Curso_Materia\'\'',
  PRIMARY KEY (`curso_id`, `materia_id`),
  INDEX `fk_Curso_has_Materia_Materia1_idx` (`materia_id` ASC) VISIBLE,
  INDEX `fk_Curso_has_Materia_Curso1_idx` (`curso_id` ASC) VISIBLE,
  CONSTRAINT `fk_Curso_has_Materia_Curso1`
    FOREIGN KEY (`curso_id`)
    REFERENCES `modelo_universidade`.`Curso` (`curso_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Curso_has_Materia_Materia1`
    FOREIGN KEY (`materia_id`)
    REFERENCES `modelo_universidade`.`Materia` (`materia_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- CHECKS
-- -----------------------------------------------------

ALTER TABLE modelo_universidade.Professor
ADD CONSTRAINT check_matricula_length 
CHECK (LENGTH(matricula) = 4);

ALTER TABLE modelo_universidade.Curso
ADD CONSTRAINT carga_horaria_3600
CHECK (carga_horaria = 3600);

ALTER TABLE modelo_universidade.Materia
ADD CONSTRAINT carga_horaria_min
CHECK (carga_horaria >= 40);

ALTER TABLE modelo_universidade.Disciplina
ADD CONSTRAINT qtd_vagas_max 
CHECK (qtd_vagas <= 60);

ALTER TABLE modelo_universidade.Disciplina
ADD CONSTRAINT check_semestre
CHECK (semestre IN ('1', '2'));

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

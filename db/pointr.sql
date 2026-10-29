CREATE DATABASE IF NOT EXISTS pointr
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE pointr;


CREATE TABLE Tecnico (
  id_tecnico        INT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(100) NOT NULL,
  email             VARCHAR(100) UNIQUE NOT NULL,
  cref              VARCHAR(100) UNIQUE,                  
  categoria_atuacao VARCHAR(100) NOT NULL,
  plano             ENUM('basico','com_video') NOT NULL DEFAULT 'basico',
  salvar_video_nuvem BOOLEAN NOT NULL DEFAULT FALSE        
) ENGINE=InnoDB;


CREATE TABLE Time (
  id_time    INT PRIMARY KEY AUTO_INCREMENT,
  nome       VARCHAR(100) NOT NULL,
  id_tecnico INT NOT NULL,
  FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico),
  INDEX idx_time_tecnico (id_tecnico)
) ENGINE=InnoDB;


CREATE TABLE Jogador (
  id_jogador      INT PRIMARY KEY AUTO_INCREMENT,
  id_time         INT NOT NULL,
  nome            VARCHAR(100) NOT NULL,
  data_nascimento DATE NOT NULL,
  altura          DECIMAL(3,2) NOT NULL,                  
  peso            DECIMAL(5,2) NOT NULL,                 
  n_camisa        INT NOT NULL,
  posicao         VARCHAR(30) NOT NULL,
  FOREIGN KEY (id_time) REFERENCES Time(id_time),
  UNIQUE (id_time, n_camisa),
  INDEX idx_jogador_time (id_time)
) ENGINE=InnoDB;

CREATE TABLE Sessao (
  id_sessao     INT PRIMARY KEY AUTO_INCREMENT,
  data          DATE NOT NULL,
  hora_inicio   TIME NOT NULL,
  hora_fim      TIME,                                      
  cobertura_pct DECIMAL(5,2),                              
  status_sync   ENUM('pendente','sincronizada') NOT NULL DEFAULT 'pendente',
  INDEX idx_sessao_data (data)
) ENGINE=InnoDB;

CREATE TABLE Sessao_Time (
  id_sessao INT,
  id_time   INT,
  PRIMARY KEY (id_sessao, id_time),
  FOREIGN KEY (id_sessao) REFERENCES Sessao(id_sessao),
  FOREIGN KEY (id_time)   REFERENCES Time(id_time)
) ENGINE=InnoDB;


CREATE TABLE Rastreamento (
  id_rastreamento   INT PRIMARY KEY AUTO_INCREMENT,
  id_sessao         INT NOT NULL,
  id_track          INT NOT NULL,                          
  id_jogador        INT NULL,                              
  saltos            INT DEFAULT 0,
  arremessos        INT DEFAULT 0,
  distancia_corrida DECIMAL(8,2) DEFAULT 0,                
  FOREIGN KEY (id_sessao)  REFERENCES Sessao(id_sessao),
  FOREIGN KEY (id_jogador) REFERENCES Jogador(id_jogador),
  UNIQUE (id_sessao, id_track),
  INDEX idx_rastreamento_jogador (id_jogador)
) ENGINE=InnoDB;


CREATE TABLE Video (
  id_video      INT PRIMARY KEY AUTO_INCREMENT,
  id_sessao     INT NOT NULL,
  com_anotacoes BOOLEAN NOT NULL,
  caminho       VARCHAR(255) NOT NULL,
  na_nuvem      BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (id_sessao) REFERENCES Sessao(id_sessao),
  INDEX idx_video_sessao (id_sessao)
) ENGINE=InnoDB;

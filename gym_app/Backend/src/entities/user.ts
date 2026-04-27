import { Entity, PrimaryGeneratedColumn, Column, OneToMany, ManyToMany } from "typeorm";
import { Trainer } from "./trainer";
import { User_Trainer } from "./user_trainer";

export enum UserRole {
    ADMIN = 'admin',
    USER = 'user'
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  email: string;

  @Column()
  password: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER
  })
  role: UserRole;

  @ManyToMany(() => Trainer, (trainer) => trainer.user)
  trainer: Trainer[];

  @OneToMany(() => User_Trainer, user_trainer => user_trainer.user)
  user_trainers: User_Trainer[];
}
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'COACH', 'NUTRITIONIST', 'STUDENT');

-- CreateEnum
CREATE TYPE "RegistrationType" AS ENUM ('CREF', 'CRN');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PAID', 'PENDING', 'OVERDUE');

-- CreateEnum
CREATE TYPE "ProfessionalType" AS ENUM ('COACH', 'NUTRITIONIST');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProfessionalProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "registrationType" "RegistrationType" NOT NULL,
    "registrationId" TEXT NOT NULL,
    "specialty" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProfessionalProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StudentProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "coachId" TEXT,
    "nutritionistId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StudentProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Biometrics" (
    "id" TEXT NOT NULL,
    "studentProfileId" TEXT NOT NULL,
    "dateOfBirth" TIMESTAMP(3) NOT NULL,
    "biologicalSex" TEXT NOT NULL,
    "menstrualCycleImpact" TEXT,

    CONSTRAINT "Biometrics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HealthRecord" (
    "id" TEXT NOT NULL,
    "studentProfileId" TEXT NOT NULL,
    "healthIssues" TEXT,
    "hypertension" TEXT,
    "diabetes" TEXT,
    "cardiacIssues" TEXT,
    "mentalHealth" TEXT,
    "steroidUse" TEXT,
    "dailyMedication" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "HealthRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Medication" (
    "id" TEXT NOT NULL,
    "healthRecordId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "pathology" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Medication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Lifestyle" (
    "id" TEXT NOT NULL,
    "studentProfileId" TEXT NOT NULL,
    "stressLevel" TEXT,
    "sleepHours" TEXT,
    "dietQuality" TEXT,
    "alcoholConsumption" TEXT,
    "smoking" TEXT,

    CONSTRAINT "Lifestyle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PhysicalTraining" (
    "id" TEXT NOT NULL,
    "studentProfileId" TEXT NOT NULL,
    "activityLevel" INTEGER NOT NULL,
    "weeklyFrequency" TEXT,
    "currentActivities" TEXT,
    "goals" TEXT,
    "perceivedImpact" TEXT,
    "bodyComfort" TEXT,
    "exerciseRestriction" TEXT,
    "restrictedExercise" TEXT,
    "preferredShift" TEXT,

    CONSTRAINT "PhysicalTraining_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FinancialConfig" (
    "id" TEXT NOT NULL,
    "studentProfileId" TEXT NOT NULL,
    "coachDueDate" INTEGER,
    "nutritionistDueDate" INTEGER,

    CONSTRAINT "FinancialConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "professionalId" TEXT NOT NULL,
    "serviceType" "ProfessionalType" NOT NULL,
    "amount" DECIMAL(65,30),
    "dueDate" TIMESTAMP(3) NOT NULL,
    "paymentDate" TIMESTAMP(3),
    "status" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "ProfessionalProfile_userId_key" ON "ProfessionalProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "StudentProfile_userId_key" ON "StudentProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Biometrics_studentProfileId_key" ON "Biometrics"("studentProfileId");

-- CreateIndex
CREATE UNIQUE INDEX "HealthRecord_studentProfileId_key" ON "HealthRecord"("studentProfileId");

-- CreateIndex
CREATE UNIQUE INDEX "Lifestyle_studentProfileId_key" ON "Lifestyle"("studentProfileId");

-- CreateIndex
CREATE UNIQUE INDEX "PhysicalTraining_studentProfileId_key" ON "PhysicalTraining"("studentProfileId");

-- CreateIndex
CREATE UNIQUE INDEX "FinancialConfig_studentProfileId_key" ON "FinancialConfig"("studentProfileId");

-- AddForeignKey
ALTER TABLE "ProfessionalProfile" ADD CONSTRAINT "ProfessionalProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_coachId_fkey" FOREIGN KEY ("coachId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_nutritionistId_fkey" FOREIGN KEY ("nutritionistId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Biometrics" ADD CONSTRAINT "Biometrics_studentProfileId_fkey" FOREIGN KEY ("studentProfileId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HealthRecord" ADD CONSTRAINT "HealthRecord_studentProfileId_fkey" FOREIGN KEY ("studentProfileId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Medication" ADD CONSTRAINT "Medication_healthRecordId_fkey" FOREIGN KEY ("healthRecordId") REFERENCES "HealthRecord"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Lifestyle" ADD CONSTRAINT "Lifestyle_studentProfileId_fkey" FOREIGN KEY ("studentProfileId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PhysicalTraining" ADD CONSTRAINT "PhysicalTraining_studentProfileId_fkey" FOREIGN KEY ("studentProfileId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FinancialConfig" ADD CONSTRAINT "FinancialConfig_studentProfileId_fkey" FOREIGN KEY ("studentProfileId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_professionalId_fkey" FOREIGN KEY ("professionalId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
